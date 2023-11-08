Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912283067D
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qwgyk2QU"
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F1919A5
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 08:11:50 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-507a62d4788so9655831e87.0
        for <linux-cifs@vger.kernel.org>; Wed, 08 Nov 2023 08:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699459909; x=1700064709; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Rj6zXcT/X6s+yAHR2OmWm/DniFC5nZ0i1ak2vOJzVI=;
        b=Qwgyk2QUt82q5tPL7JQSirPTDfKNL/UG6ferzxri1ZseKw5NpW5+cMBfD78MpQAGG2
         xzmcUujZ49YEp7rnEreZptL95Bn8GZvLqP0i6dEnZryY9xFuP6/n28tq9/KUwZejbUX6
         crKgx6WrQ/iVtzmEKSqCm1NgnXE6rPbjpEamEkNPi30sCKHVMJduTle0D0D/rQ2i9Rn5
         XyKxdQtQLHKcgBtj3nQ5YQDO266EfI7s+oRjA/lSryl6wYulj2b18qiGEzPzRM5Qb1c7
         iGQZFcoaoQQSQKelBsEQwF8mEqzN2z2pu59DM4/XaBmF+WcBV2rFCdeRPVHqVEykCGhT
         qD4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699459909; x=1700064709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Rj6zXcT/X6s+yAHR2OmWm/DniFC5nZ0i1ak2vOJzVI=;
        b=jbQEZ8w0YNjihfc0O3u6wNfDLDZjEob33n5vZ5mrrPrYNA/fJ7bBT2YrUUMMacRGPo
         FLSUcGnXu2DfZJWju5qndOBhujS9yX3Fpbfy9j1EcFUQWSSJ7si6QTWoSKTDyAD7qy3C
         0uQN5LzgTthXx5hmumCDPPKtOU096wAsfgF2VThbURnsStKbkn5By2IH4lqyuzwqD5wM
         T2QPTSSdm3wnxzPk5Cfk50w5twceztLOPBw9HBt4UL97YN6XbBts9U5Ha70TcbQKm9bC
         keKoNCX+qT6lDMwN6knnNsbtcgZcUag10LVq2soysn5G/bqymsMMpizZqXIsWWUlBSzC
         Rw6w==
X-Gm-Message-State: AOJu0YwNQL8FlLINdyUREo7YolEwYGdyJIfnziooZYLhqiEurJcxdBoc
	uZs6kk+8SPpmXFVMEUOS7BYmCG7Oo8gZz6AbxERmIa6bcPZKgV1q
X-Google-Smtp-Source: AGHT+IHxVcHDaMBLgD5gzjin/tRP5D1ozTVM8QKLn/n/t6vR2/aY1WEy96kWIDaHlYWTYHwYOYXNxywUqrjk0dhLnoY=
X-Received: by 2002:a05:6512:2207:b0:509:130f:dfa4 with SMTP id
 h7-20020a056512220700b00509130fdfa4mr1987849lfu.52.1699459908532; Wed, 08 Nov
 2023 08:11:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-9-sprasad@microsoft.com>
 <ffa541bac7417c9dea79c73e22de1eda.pc@manguebit.com> <CANT5p=ph84SkoXf-2q7oa1nQdfjw4q7jzzWOtU-mWMtg2=TxnA@mail.gmail.com>
 <CANT5p=qhjFzZJMC8i9Qt6zHomZvCCRdNiQ0koFTdQirO6GBgHQ@mail.gmail.com> <c7eef14c50dc56ce00bc202e6c2f99ca.pc@manguebit.com>
In-Reply-To: <c7eef14c50dc56ce00bc202e6c2f99ca.pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 8 Nov 2023 10:11:37 -0600
Message-ID: <CAH2r5muG34r_RHSG5c1OdA8gPdvwvAAmeuEdHp6ndfrAEpM-8Q@mail.gmail.com>
Subject: Re: [PATCH 09/14] cifs: add a back pointer to cifs_sb from tcon
To: Paulo Alcantara <pc@manguebit.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, bharathsm.hsk@gmail.com, 
	linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added RB for you for this and for "cifs: Fix encryption of cleared,
but unset rq_iter ..."

Let me know if any more RB or Acked-by for the other 11 in for-next

fce2374a6ce1 (HEAD -> for-next) smb3: fix caching of ctime on setxattr
8cc431e2afba smb3: more minor cleanups for session handling routines
2828c39da33f smb3: minor cleanup of session handling code
e8c286d1fb82 cifs: update internal module version number for cifs.ko
a25ebba8a4f2 smb3: minor RDMA cleanup
091578169aa4 cifs: handle when server stops supporting multichannel
a340e7145da5 cifs: handle when server starts supporting multichannel
693358495264 cifs: reconnect work should have reference on server struct
e935ee282ccf cifs: do not pass cifs_sb when trying to add channels
4266585b23f4 cifs: account for primary channel in the interface list
6dbc7a50c5e4 cifs: distribute channels across interfaces based on speed
44a65e388107 cifs: handle cases where a channel is closed
37de5a80e932 cifs: Fix encryption of cleared, but unset rq_iter data buffer=
s

Am trying to work on a few patches today (e.g. caching root handle
across mount when no dir leases support to reduce open and close)
and how we might save off an "altpassword" when servers do "key
rotation" (where you move from one password to another but don't want
to risk sessions going down for a while for that user).  Let me know
if any patches/features for you in next few days of merge window

On Wed, Nov 8, 2023 at 9:24=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > Here's the replacement patch for "cifs: add a back pointer to cifs_sb f=
rom tcon"
>
> Looks good,
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>



--=20
Thanks,

Steve
