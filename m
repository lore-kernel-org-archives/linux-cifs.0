Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40C215A6
	for <linux-cifs@vger.kernel.org>; Sat,  2 Dec 2023 00:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DPHNLZdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B51C433CA
	for <linux-cifs@vger.kernel.org>; Sat,  2 Dec 2023 00:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701475557;
	bh=++MCZ2Ieb2OAcuZdg75MIKfVpHHcuNL5UKJBnW1OacA=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=DPHNLZdB5VxBgqEcZ3osIphufNTXWCe6PWxnvANxzkXkrJjJAA5TvYYmTDR9hji6z
	 i2y0Mys8E9SSq/iQPnsOfXfNwZCWWJNJiAMaW7yHaBdjBKt+pTVtajdfHSHbAU32X6
	 ZHxBJ2Ds8T06+2V28BSvvf85Uv8qUEzNzfWZQS+y1y16+GNp7+sOnGAF/kddUEU/SU
	 VHaIxnbvcFx76wRfHSqf3TjDeVchnBkyUGX0jO6U8Ok+HdrdvmDlib7LSVEkVKFiQ8
	 N6VxoBM525zX1vD0jOH0qX03uXiGyRBQwYZFMlSnHHFA4xXi6q+tsEqWzDnBJPsZYd
	 PbG9bpwQOsK8g==
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-1efabc436e4so675919fac.1
        for <linux-cifs@vger.kernel.org>; Fri, 01 Dec 2023 16:05:57 -0800 (PST)
X-Gm-Message-State: AOJu0Yx4xqBELirB9WI58OuR1GYhhzjPoNH8gbnuzjV5wAzIoW31oLoT
	xYNAbZs0kEnqu7nuSdk2vhTCT9YBInE8errXIso=
X-Google-Smtp-Source: AGHT+IHfJEt6Kiqc8EsiffCOQNMm3V+dOfFDV8YCqGGSrLmMIBRjbSthL8g3D2875db3NA4b4wm/zcEnAC5Kigj4O5Y=
X-Received: by 2002:a05:6871:8782:b0:1fa:fa0a:bb40 with SMTP id
 td2-20020a056871878200b001fafa0abb40mr410830oab.18.1701475556660; Fri, 01 Dec
 2023 16:05:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:ac9:72d3:0:b0:507:5de0:116e with HTTP; Fri, 1 Dec 2023
 16:05:55 -0800 (PST)
In-Reply-To: <3755038.1701447306@warthog.procyon.org.uk>
References: <3755038.1701447306@warthog.procyon.org.uk>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 2 Dec 2023 09:05:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9ijC1ypq=JUgkmtgaN6KDUxLiUr_RT+Ju7kXNadRwhrw@mail.gmail.com>
Message-ID: <CAKYAXd9ijC1ypq=JUgkmtgaN6KDUxLiUr_RT+Ju7kXNadRwhrw@mail.gmail.com>
Subject: Re: cifs hardlink misbehaviour in generic/002?
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, ronniesahlberg@gmail.com, aaptel@samba.org, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

2023-12-02 1:15 GMT+09:00, David Howells <dhowells@redhat.com>:
>
> Hi Steve,
Hi David,

We have already sent the fixes on this week, So It has been in the
latest linus master.
Could you please check it on the latest master or after applying
commit 4274a9dc6aeb "ksmbd: separately allocate ci per dentry" ?

Thanks.
>
> I've seeing some weird behaviour in the upstream Linux cifs filesystem
> that's
> causing generic/002 to fail.  The test case makes a file and creates a
> number
> of hardlinks to it, then deletes those hardlinks in reverse order, checking
> the link count on the original file each time it removes one.
>
> However, I'm seeing the original file disappear when the most recent link
> is
> removed, leading to the check for the link count to fail due to $x
> evaluating
> blank and the '[' program complaining about syntax.
>
> I've distilled the testcase down to a small shell script:
>
> 	#!/bin/sh
> 	TEST_DIR=/xfstest.test/tmp/
> 	top=3
> 	if [ ! -d $TEST_DIR ]
> 	then
> 	    mkdir $TEST_DIR || exit $?
> 	else
> 	    rm $TEST_DIR/foo.*
> 	fi
> 	touch $TEST_DIR/foo.1
> 	for ((l=2; l<=$top; l++))
> 	do
> 	    ln -v $TEST_DIR/foo.1 $TEST_DIR/foo.$l
> 	done
> 	ls $TEST_DIR
> 	for ((l=$top; l>=1; l--))
> 	do
> 	    if [ ! -f $TEST_DIR/foo.1 ]
> 	    then
> 		echo "Arrgh, foo.1 is missing!"
> 		ls $TEST_DIR
> 		exit 1
> 	    fi
> 	    x=`stat -c %h $TEST_DIR/foo.1`
> 	    if [ "$l" -ne $x ]
> 	    then
> 		echo "Arrgh, incorrect link count"
> 		$here/src/lstat64 $TEST_DIR/foo.1
> 		status=1
> 	    fi
> 	    rm -v -f $TEST_DIR/foo.$l
> 	done
>
> that I'm running on a Linux v6.6 ksmbd share mounted with:
>
> 	mount //192.168.6.1/test /xfstest.test -o
> user=...,pass=...,noperm,vers=3.1.1,cache=loose
>
> The server includes the following settings:
>
>         server role = standalone server
>         log level = 1
>         security = user
>         load printers = no
>         #smb3 encryption = yes
>         netbios name = SMBD
>         server multi channel support = yes
>         smb2 leases = yes
>
> The output I see is:
>
> 	'/xfstest.test/tmp//foo.2' => '/xfstest.test/tmp//foo.1'
> 	'/xfstest.test/tmp//foo.3' => '/xfstest.test/tmp//foo.1'
> 	foo.1  foo.2  foo.3
> 	removed '/xfstest.test/tmp//foo.3'
> 	Arrgh, foo.1 is missing!
> 	foo.1  foo.2  foo.3
>
> I've attached a wireshark trace of the script being run.
>
> I see a lot of STATUS_DELETE_PENDING apparently being applied to foo.1.
>
> David
>
>
