Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F901DFC9
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 13:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lVs+o20q"
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3971230CF
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 05:49:35 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2c742186a3bso7658381fa.1
        for <linux-cifs@vger.kernel.org>; Thu, 09 Nov 2023 05:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699537773; x=1700142573; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7s7e/VNt+NdD30aT4J2Yq7aNwBatKy7aecNDvC5Ok6k=;
        b=lVs+o20qpd9NgpsHM7Iq62SOc27FsI9bv/fW70RCm+RGASCeOQf4APQvsEmXA9KUpR
         Ipcwc/TpQZaKTJv1oaFHMxJ2lzCeXwUGQZsRzVs/eP2008qY3HBUXYvFmtbQ6MeZGPuZ
         WRpnFJIjEyQ81i1taKXj8fc/hYfC4BEaMp+tAKlazk7O6ZrfApCTJS0vN3YS/XGnpm5G
         IJbrjGrPVSYAD4t+TNN82Ty/IIzjUtbyLP9bKbpv3Za4C74ojyXTfCTuBuzmi4cOKieB
         ibDA3q3Z88WJW9I3e1vS0jn1IjyK/HFzWb4yTZoAh8uzXwLLHrud7KzlrgSub/xtRfwC
         jDHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699537773; x=1700142573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7s7e/VNt+NdD30aT4J2Yq7aNwBatKy7aecNDvC5Ok6k=;
        b=s6gS9rE66IJYxH6vtH4lkdgE6ThJRnXidPizwl3i1xXew8nyxyldTK6mtuWbEWIlcF
         m0s7sGyvuREAHdTOz95bbL/81Z9nLf8WF0Cx5JWHtNBHkxnjzjSOsrvQySpfuZrFX99Y
         COQ/nZ9WUWxrCsvpObuDoEa9ohBqnCyTvW7c7XMYqs3MrK0ri4rrELjrdNboJ86wRbKD
         hMqzA68wpZ/R0BNN930/5IV1M088b4JGPyfQRul/Fjl/UoC642W4Kp/lAhiVXJIji5MG
         RBUEZtyPsomIJDCAdc0ZNk4HVH7sta0+m3Xz3i2ai7zZF1TQVs/ZAX2aD9cPSycuQ9O4
         HHBg==
X-Gm-Message-State: AOJu0YzWnZR7UXqSWlF654eIGDzMASfct7wMdN7pYSoUo/mHyoyuc4qD
	TQTjPsWd5OV8kSunJph/Lgl4UtEI0pws04q+l4A=
X-Google-Smtp-Source: AGHT+IEMZhy73so3UjIqzgmokwc9qfQEBbU9hKbHVvVIaRPaEoMD7VXwwhh8iZo5VxEryJEdBHfKrLCxNHaoamKXGIk=
X-Received: by 2002:a2e:9ec5:0:b0:2bf:ab17:d48b with SMTP id
 h5-20020a2e9ec5000000b002bfab17d48bmr4225044ljk.34.1699537773010; Thu, 09 Nov
 2023 05:49:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-12-sprasad@microsoft.com>
 <5890a4eec52f50b271ba8188f1ace1c9.pc@manguebit.com> <147809311fa1593993c7852e32fa52fd.pc@manguebit.com>
 <CANT5p=pawpExEBXp93rK-kmoBPRY4QDMiyXvDCv7Ug0_vrxUPQ@mail.gmail.com> <abf890046207efea833cf9f5f9d589ab.pc@manguebit.com>
In-Reply-To: <abf890046207efea833cf9f5f9d589ab.pc@manguebit.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 9 Nov 2023 19:19:21 +0530
Message-ID: <CANT5p=pJ5cXB+U3Zk=V_1Kzt5pkVidmgBZ_rxqmd1-Nisc6-NA@mail.gmail.com>
Subject: Re: [PATCH 12/14] cifs: handle when server stops supporting multichannel
To: Paulo Alcantara <pc@manguebit.com>
Cc: smfrench@gmail.com, bharathsm.hsk@gmail.com, linux-cifs@vger.kernel.org, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 9, 2023 at 6:58=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > On Thu, Nov 9, 2023 at 1:11=E2=80=AFAM Paulo Alcantara <pc@manguebit.co=
m> wrote:
> >>
> >> > and leaked server connections
> >> >
> >> >       Display Internal CIFS Data Structures for Debugging
> >> >       ---------------------------------------------------
> >> >       CIFS Version 2.46
> >> >       Features: DFS,FSCACHE,STATS2,DEBUG2,ALLOW_INSECURE_LEGACY,CIFS=
_POSIX,UPCALL(SPNEGO),XATTR,ACL,WITNESS
> >> >       CIFSMaxBufSize: 16384
> >> >       Active VFS Requests: 0
> >> >
> >> >       Servers:
> >> >       1) ConnectionId: 0x70e Hostname: w22-root2.gandalf.test
> >> >       ClientGUID: 44DAE383-3E91-3042-85FE-87D6F17298B7
> >> >       Number of credits: 1,1,1 Dialect 0x210
> >> >       Server capabilities: 0x300007
> >> >       TCP status: 4 Instance: 77
> >> >       Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net names=
pace: 4026531840
> >> >       In Send: 0 In MaxReq Wait: 0
> >> >       DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link10
> >> >
> >> >               Sessions:
> >> >                       [NONE]
> >> >       2) ConnectionId: 0x706 Hostname: w22-root2.gandalf.test
> >> >       ClientGUID: C8CF45E4-F70D-DF40-8821-0234A2E20DD4
> >> >       Number of credits: 1,1,1 Dialect 0x210
> >> >       Server capabilities: 0x300007
> >> >       TCP status: 4 Instance: 81
> >> >       Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net names=
pace: 4026531840
> >> >       In Send: 0 In MaxReq Wait: 0
> >> >       DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link6
> >> >
> >> >               Sessions:
> >> >                       [NONE]
> >> >       3) ConnectionId: 0x6ae Hostname: w22-root1.gandalf.test
> >> >       ClientGUID: AB059CDD-12FF-B94D-B30C-9E1928ACBA95
> >> >       Number of credits: 1,1,1 Dialect 0x210
> >> >       Server capabilities: 0x300007
> >> >       TCP status: 4 Instance: 96
> >> >       Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net names=
pace: 4026531840
> >> >       In Send: 0 In MaxReq Wait: 0
> >> >       DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link9
> >> >
> >> >               Sessions:
> >> >                       [NONE]
> >> >         ...
> >>
> >> I ended up with a simple reproducer for the above
> >>
> >>         mount.cifs //srv/share /mnt/1 -o ...,echo_interval=3D10
> >>         iptables -I INPUT -s $srvaddr -j DROP
> >>         stat -f /mnt/1
> >>         # check dmesg for "BUG: sleeping function called from invalid =
context"
> >>         iptables -I INPUT -s $srvaddr -j ACCEPT
> >>         stat -f /mnt/1
> >>         umount /mnt/1
> >>         # check /proc/fs/cifs/DebugData for leaked server connection
> >
> > Ack. I'll try and get a repro locally and debug this one.
>
> This should be related to patch 10/14 as you're taking an extra
> reference of @server over reconnect, and when the client reconnects and
> umount, that reference don't seem to be put afterwards.

The idea is that the reference is put in the reconnect worker.
I think the issue is that I don't drop the final reference if
cancel_delayed_work_sync was able to cancel a work.
Let me work on the updated patch.

Also, I found the reason for "BUG: sleeping function called from
invalid context". I've enabled CONFIG_DEBUG_ATOMIC_SLEEP in my test
config now.

--=20
Regards,
Shyam
