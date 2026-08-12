Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF6C423A83
	for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 10:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786530370; cv=none; b=Xp+LyACG1JMbCgdsvdF49rQv2U4kHWJFqh5qrRAAF245tQWv+pI0u9v3zej/07hGs6yPR182Gc8xxFUnKkjh4e/A6omg0jpFR4pjShjGSXSmvFE3Au8N47d9PSsyJzH1dhlmUWsYPYIBHwDazAao+QvpVzQGDHYqpojcHoNRBnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786530370; c=relaxed/simple;
	bh=CPNM/o6KOIlx9zQO6w5M+Mj0RnDcI+XJ1QfLglhyX+8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ewDqj5rCKhdF7jm5/MSEKcw0K5XZQmeFnUUrT/8DLPGbkOyEV+oz1tj9l81qYt045iIPe2KtzNOQBN7XuXwc/GYEfVkfG9r0JigqVDqPQ33k0yhjmsFF2gmOStzbGtMUUCQ5ldp/UIg8PYNc86Wh8PvPkTCVdtTs3xio5s3D5Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hsNw9UF4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hsNw9UF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB4D1F00A3E
	for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 10:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786530368;
	bh=tTCjUqBl7ErwkS5slgQCJqwS99lYRqd1ktu2HUNcxJ0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hsNw9UF4fC9MdmnVBV0Cwx2EgDXbvD3LC7TZZvVO4Ws3mRYcTn2cSiZ5lzTIetoaq
	 +5tXnh41lpnXtZeDRs9p7xYm2bIAIgm/S+CWAMl4hRbYspNw6yG01aQjSVB6Ybb44b
	 tX11aIVOVXs3tB7vaZ0jSyizFpBGniuJiGopZ9E7ymLJ+hMCU5fpeHsyx6+olK7AQh
	 e1Tq5/wOdB/O1OnNLUThog3Vh1ePp62CTZhN5TO+DA1jPO+SEEtdInDdUYcJo7wbr8
	 bYUB567x/qlcne/DfWG9KpFi/tQRQW3S2bhIZPIqGwa4jt79PNs8OlSwqtyI+NXilX
	 RpcyukbDzrS1Q==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c20363107f4so74560066b.2
        for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 03:26:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqwsjkTOUaoupEot4oFnjKHJXbeoAB5n/ydvidoGvkWx6Xp8bpkQXA2htFNqgFF5zNIl+GB8s1tmUf3@vger.kernel.org
X-Gm-Message-State: AOJu0YzMsKkYO/saILvZTBuUibgEL78luDT2DO73Gmsay4X7RFQHmCJa
	a4d8Y/4m0pZckwJmKWLEDKIahMMKKvhaMvX/5mbhE0WVv3qa3pVhJSr89nwI/OuMZXe6ZJSJDrl
	9q0KEmVO1irYYzM87alsT8qxHki3aoz0=
X-Received: by 2002:a17:907:8dcd:b0:c1f:b883:ed3b with SMTP id
 a640c23a62f3a-c20f2e3d704mr167785766b.4.1786530366873; Wed, 12 Aug 2026
 03:26:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260809161916.1071530-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd84UnfdQ6Ef2nqybnhdgURFo9uYpB1mHZpphFyCiMhutA@mail.gmail.com> <caad5646-eba3-4629-9a21-c2000a37c0f3@chenxiaosong.com>
In-Reply-To: <caad5646-eba3-4629-9a21-c2000a37c0f3@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 12 Aug 2026 19:25:52 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9TcsD3L0eY0Fg724nm7He8Bp3DLrC2tvAwG6Owi5DAvw@mail.gmail.com>
X-Gm-Features: AUfX_myVfBIlQ1VyNH4V_HsmVw292GHl7i4ecLL_L94woOHBxPziNxtDEYjt0rA
Message-ID: <CAKYAXd9TcsD3L0eY0Fg724nm7He8Bp3DLrC2tvAwG6Owi5DAvw@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] ksmbd: refactor smb2_notify() to a blocking wait
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, tom@talpey.com, 
	senozhatsky@chromium.org, slow@samba.org, gael.blivet@gmail.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 12, 2026 at 3:59=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> I am trying to setup kerberos test environment. If you have any better
> related documentation, that would be very helpful to me.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
                    ksmbd Kerberos v5 Setup & Test Guide
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

1. Kernel & Build Requirements
---------------------------------------------------------------------------=
-----
1. Ensure your Linux kernel is compiled with Kerberos v5 support enabled:

     CONFIG_SMB_SERVER_KERBEROS5=3Dy

2. Build ksmbd-tools (ksmbd.mountd) with Kerberos 5 support (--enable-krb5)=
:

     $ sudo apt update
     $ sudo apt install libkrb5-dev glib-2.0-dev libnl-3-dev libnl-genl-3-d=
ev

     $ ./autogen.sh
     $ ./configure --enable-krb5
     $ make
     $ sudo make install

   Verify Kerberos library linkage:
     $ ldd $(which ksmbd.mountd) | grep -i krb


2. KDC Setup & Principal/Keytab Generation
---------------------------------------------------------------------------=
-----
Install KDC packages:
  $ sudo apt update
  $ sudo apt install krb5-kdc krb5-admin-server

Create principals and keytab using kadmin.local:
  $ sudo kadmin.local

  Inside kadmin.local:
    addprinc linkinjeon@KSMBD.TEST
    addprinc -randkey cifs/ksmbd.test@KSMBD.TEST
    ktadd -k /etc/ksmbd/ksmbd.keytab cifs/ksmbd.test@KSMBD.TEST
    quit

Verify the generated keytab:
  $ sudo klist -kte /etc/ksmbd/ksmbd.keytab


3. ksmbd.conf Configuration
---------------------------------------------------------------------------=
-----
Add Kerberos settings under the [global] section in /etc/ksmbd/ksmbd.conf:

  [global]
      kerberos support =3D yes
      kerberos keytab file =3D /etc/ksmbd/ksmbd.keytab
      kerberos service name =3D cifs/ksmbd.test@KSMBD.TEST
      workgroup =3D KSMBD


4. Service Restart Procedure
---------------------------------------------------------------------------=
-----
Restart services and reload kernel module:

  $ sudo ksmbd.control --shutdown
  $ sudo modprobe -r ksmbd
  $ sudo modprobe ksmbd
  $ sudo ksmbd.mountd


5. Kerberos Authentication Verification
---------------------------------------------------------------------------=
-----
Verify Kerberos ticket acquisition independently of SMB:

  $ kdestroy
  $ kinit linkinjeon@KSMBD.TEST
  $ kvno cifs/ksmbd.test@KSMBD.TEST
  $ klist -e


6. SMB Test Execution
---------------------------------------------------------------------------=
-----
Run smbtorture with strict Kerberos authentication and FQDN:

  $ ./bin/smbtorture //ksmbd.test/cifsd-test3/
-Ulinkinjeon@KSMBD.TEST%1234 --use-kerberos=3Drequired
smb2.session.expire2e
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
