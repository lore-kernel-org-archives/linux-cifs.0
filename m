Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35C91BDF4
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 11:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J0/qUJIS"
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B0D269A
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 03:44:56 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2c5071165d5so9931581fa.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 Nov 2023 03:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699530295; x=1700135095; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SfJ2AK6bCEjlGgsnvXjoIWz0JmkeWZi+5ZIEgtZfk80=;
        b=J0/qUJISto27UoqGIIiqex/SmmK+THyjxTu002h9xMqeoAHwzWmKRf0dPLkqpWft/k
         VpfJ8SZ0/Dxzp/TE3hgB7ocrvx2UR2LWfbw1VTvtP7R/bzgF0n94FhNDy/qMcfjbDNT7
         cazkgAhqvLBoeW1seai/a3a/UpjQOPuAYB9daJeIdUzosgTEtnl5B2XAq25uS2YpRgyK
         4nK9PqsId2mucLxFtSpKOA7gmcq8X8ESVaqmw7Zv5NihrTijHPBHVfI84roa3OXRk2wn
         IKiOLzy5c3ky0yRQdUg8twUaOkRbc774u9pukKGPDGKynvT8ht7e0Yy/ykL1IVj2N9PV
         +UDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699530295; x=1700135095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SfJ2AK6bCEjlGgsnvXjoIWz0JmkeWZi+5ZIEgtZfk80=;
        b=cFHdIkBmtN8wUJ6zHh5nbJzRhs78R1kim/uZ7VfhGd4MIdj/8wkgHH84EuboluCjMJ
         39tGt/Ub8czsFiSdVPuwLE/14Q5rdvWYyWznHRxCw/MjeTwMbAcHYT07NbXZaZ/Xxj+o
         /x+8kTHW2BubwoQXbuPgzqe6WArQsBTId96FNJWSiDMh5UR7BW42i+wa+Lve25Nbi3IY
         ntkWJdhaZgRW419X69TE3OSOs1OBkXwajgewzspSGzICTU1m3I8RSnhMDWFlDEkmjPbD
         C9dguw7hS4Nxe+M21cQh4I+BLhgWWArsbTI/B9EguNwHgfmedwsLqWLYjjTfxRhkifj4
         sYDQ==
X-Gm-Message-State: AOJu0YyM0CPbD4lmDqisPhKUjpRaDSNfhazdumbYaZ9va0xF+P7rDH2t
	GlMY4NgTVBGzHhtfwkydhz/hQVZXTEhbQaUqzX/sgYkMUWBjJg==
X-Google-Smtp-Source: AGHT+IF1f474J8KsXRe+LughWnbeQkfwwPOeNCXItq4BXWOyVX7Atd4T1bBp3mDTCv/hRkVZblsGYAqezpqWHJUrTfY=
X-Received: by 2002:a2e:84cc:0:b0:2c5:70e:734a with SMTP id
 q12-20020a2e84cc000000b002c5070e734amr3921191ljh.2.1699530294836; Thu, 09 Nov
 2023 03:44:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-12-sprasad@microsoft.com>
 <5890a4eec52f50b271ba8188f1ace1c9.pc@manguebit.com> <147809311fa1593993c7852e32fa52fd.pc@manguebit.com>
In-Reply-To: <147809311fa1593993c7852e32fa52fd.pc@manguebit.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 9 Nov 2023 17:14:43 +0530
Message-ID: <CANT5p=pawpExEBXp93rK-kmoBPRY4QDMiyXvDCv7Ug0_vrxUPQ@mail.gmail.com>
Subject: Re: [PATCH 12/14] cifs: handle when server stops supporting multichannel
To: Paulo Alcantara <pc@manguebit.com>
Cc: smfrench@gmail.com, bharathsm.hsk@gmail.com, linux-cifs@vger.kernel.org, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 9, 2023 at 1:11=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> > and leaked server connections
> >
> >       Display Internal CIFS Data Structures for Debugging
> >       ---------------------------------------------------
> >       CIFS Version 2.46
> >       Features: DFS,FSCACHE,STATS2,DEBUG2,ALLOW_INSECURE_LEGACY,CIFS_PO=
SIX,UPCALL(SPNEGO),XATTR,ACL,WITNESS
> >       CIFSMaxBufSize: 16384
> >       Active VFS Requests: 0
> >
> >       Servers:
> >       1) ConnectionId: 0x70e Hostname: w22-root2.gandalf.test
> >       ClientGUID: 44DAE383-3E91-3042-85FE-87D6F17298B7
> >       Number of credits: 1,1,1 Dialect 0x210
> >       Server capabilities: 0x300007
> >       TCP status: 4 Instance: 77
> >       Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net namespac=
e: 4026531840
> >       In Send: 0 In MaxReq Wait: 0
> >       DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link10
> >
> >               Sessions:
> >                       [NONE]
> >       2) ConnectionId: 0x706 Hostname: w22-root2.gandalf.test
> >       ClientGUID: C8CF45E4-F70D-DF40-8821-0234A2E20DD4
> >       Number of credits: 1,1,1 Dialect 0x210
> >       Server capabilities: 0x300007
> >       TCP status: 4 Instance: 81
> >       Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net namespac=
e: 4026531840
> >       In Send: 0 In MaxReq Wait: 0
> >       DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link6
> >
> >               Sessions:
> >                       [NONE]
> >       3) ConnectionId: 0x6ae Hostname: w22-root1.gandalf.test
> >       ClientGUID: AB059CDD-12FF-B94D-B30C-9E1928ACBA95
> >       Number of credits: 1,1,1 Dialect 0x210
> >       Server capabilities: 0x300007
> >       TCP status: 4 Instance: 96
> >       Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net namespac=
e: 4026531840
> >       In Send: 0 In MaxReq Wait: 0
> >       DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link9
> >
> >               Sessions:
> >                       [NONE]
> >         ...
>
> I ended up with a simple reproducer for the above
>
>         mount.cifs //srv/share /mnt/1 -o ...,echo_interval=3D10
>         iptables -I INPUT -s $srvaddr -j DROP
>         stat -f /mnt/1
>         # check dmesg for "BUG: sleeping function called from invalid con=
text"
>         iptables -I INPUT -s $srvaddr -j ACCEPT
>         stat -f /mnt/1
>         umount /mnt/1
>         # check /proc/fs/cifs/DebugData for leaked server connection

Ack. I'll try and get a repro locally and debug this one.

--=20
Regards,
Shyam
