Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b6QaCN4o"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD9C10DF
	for <linux-cifs@vger.kernel.org>; Fri,  1 Dec 2023 08:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701447311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=owFlkVrBlIoTrtammRMFLHamNfJ2P3ag5W3WdGGYqnQ=;
	b=b6QaCN4oUrb/iVMCiZ76sOIbD5oIcZNBOKjVSeXjLIO95ZJssthMQ+ghokB1xMy3x4bD48
	CbOlSO1gj/cVRARdSD3ObZK+bFPXV2zsL4VCCED0aYNts9vxwAVlHeR/zPaFrbClrp3vaX
	kbixF19+lMSyN8kNsPclJ7J14kEnUv8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-5z62QaXgMwGDlOJKtZQBwA-1; Fri, 01 Dec 2023 11:15:08 -0500
X-MC-Unique: 5z62QaXgMwGDlOJKtZQBwA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBE38811E82;
	Fri,  1 Dec 2023 16:15:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.161])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0C63E1121307;
	Fri,  1 Dec 2023 16:15:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
cc: dhowells@redhat.com, ronniesahlberg@gmail.com, aaptel@samba.org,
    linux-cifs@vger.kernel.org
Subject: cifs hardlink misbehaviour in generic/002?
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Date: Fri, 01 Dec 2023 16:15:06 +0000
Message-ID: <3755038.1701447306@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

--=-=-=
Content-Type: text/plain


Hi Steve,

I've seeing some weird behaviour in the upstream Linux cifs filesystem that's
causing generic/002 to fail.  The test case makes a file and creates a number
of hardlinks to it, then deletes those hardlinks in reverse order, checking
the link count on the original file each time it removes one.

However, I'm seeing the original file disappear when the most recent link is
removed, leading to the check for the link count to fail due to $x evaluating
blank and the '[' program complaining about syntax.

I've distilled the testcase down to a small shell script:

	#!/bin/sh
	TEST_DIR=/xfstest.test/tmp/
	top=3
	if [ ! -d $TEST_DIR ]
	then
	    mkdir $TEST_DIR || exit $?
	else
	    rm $TEST_DIR/foo.*
	fi
	touch $TEST_DIR/foo.1
	for ((l=2; l<=$top; l++))
	do
	    ln -v $TEST_DIR/foo.1 $TEST_DIR/foo.$l
	done
	ls $TEST_DIR
	for ((l=$top; l>=1; l--))
	do
	    if [ ! -f $TEST_DIR/foo.1 ]
	    then
		echo "Arrgh, foo.1 is missing!"
		ls $TEST_DIR
		exit 1
	    fi
	    x=`stat -c %h $TEST_DIR/foo.1`
	    if [ "$l" -ne $x ]
	    then
		echo "Arrgh, incorrect link count"
		$here/src/lstat64 $TEST_DIR/foo.1
		status=1
	    fi
	    rm -v -f $TEST_DIR/foo.$l
	done

that I'm running on a Linux v6.6 ksmbd share mounted with:

	mount //192.168.6.1/test /xfstest.test -o user=...,pass=...,noperm,vers=3.1.1,cache=loose

The server includes the following settings:

        server role = standalone server
        log level = 1
        security = user
        load printers = no
        #smb3 encryption = yes
        netbios name = SMBD
        server multi channel support = yes
        smb2 leases = yes

The output I see is:

	'/xfstest.test/tmp//foo.2' => '/xfstest.test/tmp//foo.1'
	'/xfstest.test/tmp//foo.3' => '/xfstest.test/tmp//foo.1'
	foo.1  foo.2  foo.3
	removed '/xfstest.test/tmp//foo.3'
	Arrgh, foo.1 is missing!
	foo.1  foo.2  foo.3

I've attached a wireshark trace of the script being run.

I see a lot of STATUS_DELETE_PENDING apparently being applied to foo.1.

David


--=-=-=
Content-Type: application/gzip
Content-Disposition: attachment; filename=pcap.gz
Content-Transfer-Encoding: base64

H4sICHj9aWUCA3BjYXAA7VwNWFRVGj4XBQFzGm3MKV29pBmozPIncEfU8a9oVxDFWKw0GEDhWQQZ
wPCvMDMtFcnCP7TafnbVRWvN7dFns8jNjWnDtX3MJVNS8S9/kKzctt1t9pwz594598y9lzsM8Njz
7PUZ7pxh7jnf+d7v/b7vnO9gaJ8+ofUAgJSkkXdz8O4iVwAYDR4sKssrDJ8RwU8qduSFz0yJ4Ati
I+OiE6L4SWkP8TY+1pIQ9UDyYj788YKyfD49fUqcJSYC9tED3AumFhSVV/DxlgRLVKQjJzqyKK+i
LDImKiY2Ojo6IdJeXlCYGzsSfrcniAWTy+cvyMlewIf/qsCRV5qf7fh1BB9nibLE8+EPFJTxOcXz
58Nbdk7M3NHZUdExifHZaBQAkNxI5kxyR70FgCCQV7QgvjQKgBD4aQj89DYf5AGkvyDUv7tTEP3+
tgGNY04lvATb6AUGhv3pQh3+GRUMpgCu2rrIBmxBJbX1O4IC4It7r5U7aDCd/IPTnmKsNINrVceh
hFxw6B+35yxsnpgwDLYyf0xPmWgjcgeCUHzfDF8mIsUbZQDOBmlT+RKA+/fsVUnuvSStAFAB54M+
N8NXGZgPFpDPjVBj4jX9/oJcdKflMkK50Dfy4au/TrkiANcvj/f+3MVc9DhBZBx03alzHLNKv27c
EH6ZFH7GRy8nxMN2vIhflBtFjF+4awXCr+57hB3CkDv4XivCzmBq7gPxu7Gm1I1f88QZgxCGsI82
Uf44OGAg0XWaD/iFMG2xv3AO1BuxTbj76+9nf32gfEFgMO7PF/2GeH2SSfSaCzx6DdxxOWEifI9e
LC9AnHUx0qvjppwXzX2c9tSelUZwdd1iiRePI926+2a5N8/4Hy3uLcHc26I4hhlcpbhX4R5DnXsD
yMx+e4txz6xTLn+5d5fOcXzjXnBTYKIG957G3PunnHupPQ2mLwsgfm3LwiTuDUYYanFPL356uWf2
sz+We3d1sD8P92i9/nlDsFyvNC/CrUsx94CcF18WQN1+D/V6papI4sUipFtarywv7vaTFyIZepHf
c37wgrbXgX7bq6jX/ZRenffcmbgRtjcq2etq10psrxsZe/3eYDo9G+r1+r5UyV6HIN3CVppcr+75
H/VBr7OI3gpze/OFw05wanf2OSO5D58eSPIjIGGaKNO3GfCUvhv+asYwBqjII8fDJNm3XjySgL/X
fs47TgweOCBRI04sw3Fik5wPp2c77WlTIW5fUXFiMcJOK04MukXjxM+6KU4M7rQ4sSDAg59tJ5+Y
CtvoxfIuwOZ6BuH3+1Ny3qVNNZjOHEA59mtvSLzjEYZQsmA13g3ygXecH7y7j/AusAt4J8ap/T7g
HgKSQaGO+RhVnufID1FO2pbpKxi+HqWsWG5Hnng4uNv8BbIzZG+rKX9x+32RiXNhe66Sv8i0PoH9
xRG5vzhzwGmfkQnt7XzVS5K/WIJsDrZ4JX+BriHk/rv2/YVLxV/YRH+BnrVhf9EPVMN7teQvHgVz
QTH8ZwHR5Lk0ys5grgRmlEwtRZ8vHv92ba9rE//1ykXz3po7Zu/upVOL4VR/yEYmJxdNV/uukt9y
65/FYU1FrBwHOt5mulbhePuhnPczMg2ms6dQHrN/u8T7MISFEg6cjzjMAi78+7V73XxQu7PP8QS8
cML7IIr3q7sADzU/0tiOH/HgUE+t5eZtikuERg1eUlrLVVufxPlkjZwPZ0857elLIQ4t6zzxcynC
AiWrNA69KD7wOnEQ4werT7fcqFVHyW92pgjPwffPAW87Aktdq5H8u1+W21H6UoOpRUB2lFUu2VEc
mgMyb1Z+zkf53QyoI7K2UbJ+fiBVOALfH1HSdb21Eus6V67rFgHK+yHSdVWQpOsqJC8ClJa1L6Xr
MJ2yhgGuJ+J3lqrO3VfqxVBs++zd84028tQOar5DvpsurCYs8MJmsetZjM0rDDYfwjkfhvO9nPGi
DJsqtOHAzpfzcb4BWD4k51HKF806PFvYA9t7lGLCK9blOCasYHA57LTPDMW4XJBwWe/GhctXiglo
5HuIHDs6NYd0xwSzQkyIacc3q+WUQ3XK6W9OOUznOOo55VGFNfL8DfMEjb2H53Bs+VpudzNDDabz
0RDPS7+IlOxuNMJUa+9BL5569x6G+tkfu/cwrIP9edbIbZRef/NyvnAEto8o8aTe+hTmiV3Ok/PR
ULc/Qr2eXe/xX9VIt7C1Wo0n93YzT6J94ElfYr/Iqw3XKSf0s71pP+ttx/KrnwqX1Xh0n988aiN4
A2ptVhruEJrh581KPDrqWoN5lMzw6EeD6cJBlCu3TJN4FI8wh63NamszvXiLazMxF2s/LslztAgS
33rpXJs1+rA260vmlOyDXQQo7q14+KsXV//XSiDAOy7WJS3Tiou4flKyXM73Cwed9oytEP8vqbj4
PLIBrbgYToTYeQvynY6LETrl9DcujtA5TvtxsYLi8+fnnhYyYDtDaa8l2bUW77X8Tc7njK0G06UI
lOfkchKfExCmUDKjGp/14tken09fMGjyeQThc3AX8FmMy/U+4I72Wip0zIcP0PYHje3stZiovRba
qtX8iF578t+PVCj4kR7/XqnlR3AtqKRS7kcuRTjtmXug3X1B+ZENyPa0/MjIbvYjsR30I6O6yY9E
dpofofPryaZ1Wvn1OpwXtMr9SOYeg+mrGojnmaHDJT+SiDDVyq9H6uadvvx6lJ/9sfl1ZAf7U86v
Twyp0sqvcQ2q5DE5T76qcdpnvQr1eoLKrxFPErXya8stHG/p/PrnOuXsjPw6ViO/jvKbR0r59Ucf
1Wjl11WYR1PkPJr1qsF0JQzi3XzPL1keqefXlm6KxyNJPA7p4vxar120l19HdVtcFPPrLIrvy3q/
Idhg26bE9xgrrn2VXJXz/UqY0/7IOIj/P6oqJL6/6OY7+EGtdinyb1cH+b68E2uXBopXMTrlCiMr
KpZXWfApUxLKb7IIv9J6ePS7f3edYIFt9GL51YN3rUf63fWtnF+PjDOYrg6B+j11fJ/ELyvSMZTw
khq/9OqXrS1yo29XvKvVFkcRfoV2QW3RQNX09eKC8t2POffpSdDBedGyifKK/ortV/RLemqxPan2
CnK3kJ7FOKHm59TkRX4ulGqL/ouNc13Vfwzz/c7u35PPIh4hPjVQ+/lzbu4Wdoh7/Gz9YqsV1+wc
zD751SFO+5wRkE9/X3da5q+ssA876xfEK9ZHv8DywuMXGsh+/1vUPN4bs09A5YQqpbpEpasa1yVe
kPuFOSPgXFYivzC0hfULIFmcBxyp0kDVJWJ180i83gLeNbrWK/sEjRodrnE51jJ6XwllXoj17qnR
1RC9Z7J5jnjF6ZTXrOKPPDW6c5T8H6S/IxyC7w8p6Xuf63ms7zmMvhfCOZxB+v7vdJm+a2AfS1n5
OR/l9y+enyNzzKdi+WsPfSrcD9v3K8XyRCuudZW0MBidgfO8Cef4adUTEkab3BhxQC13H02kqOvo
uTyptkneGflOW+PSOXO8TjnVc+Z8zpu7fFKTgEoy65VsablrA7alasaWbhpM186jvYTTr0u2NBbp
GvbxoFt+KB/njuminKNl2vKFu8coeY9sbxL2wvd7leR93fUClrdQLu9jk0R5373pJW+hKK+4juEY
/bVnvaPgE5zK+QPvOR4D3ue/Uw80CRrnv3F9zXFBbuvXzsN5vV1pBEep89/I1sd6zn9/Qo2x60aT
sAsxWWmMbVZce3AsUxzDDMc4y44Bcmk77Qc8oTGB3EOBtp2KtTRWb/Lvf6Iwl9CSL+RzoW1gm+tF
bAOljA28bTC1piAbWGnxsgGvuXBdOhf6nGztoJOCxjnZGrxmfUY+l6yB4lyystm5eJ+T7UFyar38
a2/NqpUL4T0cEsN6d8GalT4nq9cfdt45WZqz7+Sf1OIs3vt3nJPzqTXFac8uhpxtVOcsfRb3oemn
BY2zuHhfsGSV4hhm0Eidxd3sHkP9LK6Iz63291KCTrn83de16hzHt7O4hxouChpncTfi+lCjnNvZ
xQbT9Z0Qv8+nXZa4PQ5hqHUWVy9+7Ho5bIVv62UL4fZtXbBeps/i6sWdPYurNp/uOour14467ywu
XRc68PAlrboQ3v8sWSj3F9d3Ou05S6C9Oam6EPIX47TqQmO6xF90fn05qZv8x1i//YdSXeiH71q1
6kKbcG5wTu4/cpYYTF/3R/uZHx9n/YenLpTB1IXG6OabvrpQkp/9sXWhsR3sz1MXonly4unrWjzB
+5gl5XKefN3fac9FcbWB4smW9ngy7ifCk/HdxBNbl/Ak5vB3WjzZjHnSIudJLoyzN5ZDPD97f6HE
k/EIUy2ejOtknozvZJ7Y/OYJXU958OEAq0Y9Be/rlZyV8+TGcqc9Lwfq9SOqnrIV6VarnjKBSLH7
FqunTNQpV8fqKSnHQ6wa9ZQtuJ5yWW63eTkG0zdPQv0em1kt2a0N6VirnqJXv/7mh9EkP7y9i+sp
enFRq6f4Mq//11N+KvWU3QN6WzXqKXhf3LFI7q++edJpz58G+XSIqqcgf2XTqqdM8tEvsLzQrqe8
+W5fq0Y9ZSve33pW7hfyp8G5oD3OY66HWb+gXk+ZpJtHWvWUpov9rBr1FLyH7HiK0ft5KHMt1rtn
n6KW6F21njJZp7xmFX+kXE8Z/ll/q0Y9pRbreyaj71qD6dsJSN9NDZK+J6A5aNVT9MrfOfUUer+q
bei2JI39Krxv7jglx+jbCU57wcBKI/iA2q/6C5ontV9FjVG647NyDTvA+7KOSsUxzHAMyQ7mPeMe
Q90Opoj+ArRnB+5n1f/2jbaDuDtOlmvYwTZsB+lyOygYCOewHdlBwwHRDjJGoTlo2YFe+ZPIEx3b
i1WygytHT5Zr2AHeb3Z8wWC0Hc6zFtpBvccOEEYZo9x9I90WkjHKegeB17k3V3FgEJhUXF5Uluco
5Rc4ihcW5Obl8vZFfK77P6oKAMH4u1uiYlf1IO8z4XM94Xtx1z1QOodMoiwA4H8nLs0NbEsAAA==
--=-=-=--

