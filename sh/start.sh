#!/bin/bash

nifi_dir='/opt/nifi'

: ${KEYSTORE_PATH:?"Must specify an absolute path to the keystore being used."}
if [[ ! -f "${KEYSTORE_PATH}" ]]; then
    echo "Keystore file specified (${KEYSTORE_PATH}) does not exist."
    exit 1
fi
: ${KEYSTORE_TYPE:?"Must specify the type of keystore (JKS, PKCS12, PEM) of the keystore being used."}
: ${KEYSTORE_PASSWORD:?"Must specify the password of the keystore being used."}

: ${TRUSTSTORE_PATH:?"Must specify an absolute path to the truststore  being used."}
if [[ ! -f "${TRUSTSTORE_PATH}" ]]; then
    echo "Keystore file specified (${TRUSTSTORE_PATH}) does not exist."
    exit 1
fi
: ${TRUSTSTORE_TYPE:?"Need to set DEST non-empty"}
: ${TRUSTSTORE_PASSWORD:?"Need to set DEST non-empty"}


enable_ssl() {
    echo Configuring environment with SSL settings
    nifi_props_file=/opt/nifi/conf/nifi.properties

    sed -i '\|^nifi.security.keystore=| s|$|'${KEYSTORE_PATH}'|g' ${nifi_props_file}
    sed -i '\|^nifi.security.keystoreType=| s|$|'${KEYSTORE_TYPE}'|g' ${nifi_props_file}
    sed -i '\|^nifi.security.keystorePasswd=| s|$|'${KEYSTORE_PASSWORD}'|g' ${nifi_props_file}
    sed -i '\|^nifi.security.truststore=| s|$|'${TRUSTSTORE_PATH}'|g' ${nifi_props_file}
    sed -i '\|^nifi.security.truststoreType=| s|$|'${TRUSTSTORE_TYPE}'|g' ${nifi_props_file}
    sed -i '\|^nifi.security.truststorePasswd=| s|$|'${TRUSTSTORE_PASSWORD}'|g' ${nifi_props_file}

    # Disable HTTP and enable HTTPS
    sed -i -e 's|nifi.web.http.port=.*$|nifi.web.http.port=|' ${nifi_props_file}
    sed -i -e 's|nifi.web.https.port=.*$|nifi.web.https.port=443|' ${nifi_props_file}
}

enable_ssl

tail -F ${nifi_dir}/logs/nifi-app.log &

${nifi_dir}/bin/nifi.sh run
