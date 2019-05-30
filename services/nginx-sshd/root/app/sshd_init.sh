#!/bin/sh

: ${DISABLE_APP_USER_KEYGEN:="false"}
: ${DISABLE_CONFIG_GEN:="false"}

#create new app user of container if not exists
if [[ -n "$APP_USER" ]]
  then
    id $APP_USER >& /dev/null
    if [[ $? -ne 0 ]]
      then
        echo "`date`: ${APP_USER}: adduser -s /bin/sh -D"
        adduser -s /bin/sh -D $APP_USER
    fi

    # init password
    if [[ -n "$APP_PASSWORD_CRYPT" ]]
      then
        echo "`date`: ${APP_USER}: chpasswd -e"
        echo "${APP_USER}:${APP_PASSWORD_CRYPT}" | chpasswd -e
    elif [[ -n "$APP_PASSWORD" ]]
      then
        echo "`date`: ${APP_USER}: chpasswd -c SHA512"
        echo "${APP_USER}:${APP_PASSWORD}" | chpasswd -c SHA512
    else
        echo "`date`: ${APP_USER}: passwd -d"
        passwd -d ${APP_USER}
    fi

    #init ssh key
    if [[ "$DISABLE_APP_USER_KEYGEN" == "false" ]]
      then
        f="/home/${APP_USER}/.ssh/authorized_keys"
        if [[ ! -f $f ]]
          then
            echo "`date`: ${APP_USER}: sh-keygen"
            su - $APP_USER -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa"  < /dev/null
            su - $APP_USER -c "cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys"
            su - $APP_USER -c "chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"
        fi
    fi
fi

#init root ssh key
if [[ "$DISABLE_APP_USER_KEYGEN" == "false" ]]
  then
    f="/root/.ssh/authorized_keys"
    if [[ ! -f $f ]]
      then
        echo "`date`: root: sh-keygen"
        ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa < /dev/null
        cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys
        chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys
    fi
fi

if [[ "$DISABLE_CONFIG_GEN" != "true" ]]
 then
    echo "`date`: dockerize sshd_config template file"
    dockerize -template /app/sshd_config.tmpl:/etc/ssh/sshd_config
fi

# start sshd
echo "`date`: ssh-keygen -A"
ssh-keygen -A
echo "`date`: exec /usr/sbin/sshd"
exec /usr/sbin/sshd
