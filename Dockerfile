FROM ghcr.io/000yesnt/box86-box64-docker:main AS build

ARG DEBIAN_FRONTEND=noninteractive
ARG PUID=1000

ENV USER steam
ENV HOMEDIR "/home/${USER}"
ENV STEAMCMDDIR "${HOMEDIR}/steamcmd"

# Reference: https://github.com/CM2Walki/steamcmd/blob/master/bookworm/Dockerfile
RUN set -x \
        && apt install -y --no-install-recommends --no-install-suggests \
                libstdc++6-arm64-cross \
                curl \
                ca-certificates \
                locales \
        && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
        && dpkg-reconfigure --frontend=noninteractive locales \
	&& useradd -u "${PUID}" -m "${USER}" \
	&& su "${USER}" -c \
		"mkdir -p \"${STEAMCMDDIR}\" \
			&& curl -fsSL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C \"${STEAMCMDDIR}\" \
			&& sed -i -e 's/$DEBUGGER \"$STEAMEXE\"/box86 $DEBUGGER \"$STEAMEXE\"/' ${STEAMCMDDIR}/steamcmd.sh \
			&& ${STEAMCMDDIR}/steamcmd.sh +quit \
			&& ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${STEAMCMDDIR}/steamservice.so\" \
            && mkdir -p \"${HOMEDIR}/.steam/sdk32\" \
            && ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${HOMEDIR}/.steam/sdk32/steamclient.so\" \
            && ln -s \"${STEAMCMDDIR}/linux32/steamcmd\" \"${STEAMCMDDIR}/linux32/steam\" \
            && mkdir -p \"${HOMEDIR}/.steam/sdk64\" \
            && ln -s \"${STEAMCMDDIR}/linux64/steamclient.so\" \"${HOMEDIR}/.steam/sdk64/steamclient.so\" \
            && ln -s \"${STEAMCMDDIR}/linux64/steamcmd\" \"${STEAMCMDDIR}/linux64/steam\" \
            && ln -s \"${STEAMCMDDIR}/steamcmd.sh\" \"${STEAMCMDDIR}/steam.sh\"" \
	&& ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "/usr/lib/box64-x86_64-linux-gnu/steamclient.so"

FROM build AS steamcmd-root
WORKDIR ${STEAMCMDDIR}

FROM steamcmd-root AS steamcmd 
USER ${USER}
