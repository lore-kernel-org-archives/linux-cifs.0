Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nLb+9PxL"
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2068111
	for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 20:28:56 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-507cd62472dso4891052e87.0
        for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 20:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701059335; x=1701664135; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mWs0zAUZCHgyK9hzTG6Z0XLXxbQmHI/Fv5ekP1h46M0=;
        b=nLb+9PxL5bdD6FS5T+DTGo99Lh1rXQ7W+ZuQGhXK8jYZLJa/GQmvA1VqMC72PcudzS
         W3p7qirWxj7iPCY3LQi3L4aYwbNMR6LxmTTdjvkFWuzDTk5bVegeBAbELUpARSM9nUWc
         ByWYXOfbYzuKfoDxtbrHWu9yub0bKZtoR8TXhNhvCsuYCKkDxfCUupjpWWEp23/4fPFt
         3aN6Tix1zc8tzkA29P1z56cF21XtwguvWCmpI48Xw9wtaxwCUtj+pn+TZnhhdjd15tw2
         Atjy3rVJB9AuDu2lbDbsfv7U/Sn1KfrBLQQM8GhteUefZdvF+H5yA7nHmE1Wc980c+yz
         P8Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701059335; x=1701664135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mWs0zAUZCHgyK9hzTG6Z0XLXxbQmHI/Fv5ekP1h46M0=;
        b=remhWN0hcARWav3AfJx82hM8GUmaw1r2RCW1bkczsRuYo2a+nsaf1PkbM/wr5F5v9+
         wsgmG6YbJv2fnJ/mippWtdyMGizPKlFyHn0j1VR/DDjMHIvZ9DzQMJk1Q6QonbN49ELS
         mUZfwLDHIpcuPsrCCYh+l2sCbciAC/5V0RbKT+pY2YhwBf0JnKqG6Kj1+n60J1L26LOy
         DCZdAUg0H9MCaWn9sB8F7tsAEdWKhijRdzEpUYnoIgFx6ZGr3cclN601yWA1jKL+8i27
         5sxH44Y3XDgZHsjw+nQK3gkEzWJfpzaPiLondr7aYfncijaAyX2RZjkXBumM+OgPHFV5
         HInw==
X-Gm-Message-State: AOJu0YzaEf2hMfMGPwSXfTjcsKhSWEKuS5sFDmAGKNwP2I0P/gXsDy/g
	qXEmLivYSFSjg1e/0h1btG7uLdcVuTDeNorrQtgO2mMDHOU=
X-Google-Smtp-Source: AGHT+IH8AzOCPA7DdKDLbSmnIRB3fICu7v58sL1SmQcmdQ9ax8c4FHkalydxwrfi6X1C6biHWu59BT1vEhO2VPOeYuk=
X-Received: by 2002:a05:6512:1383:b0:50b:b216:fe18 with SMTP id
 fc3-20020a056512138300b0050bb216fe18mr406535lfb.2.1701059334463; Sun, 26 Nov
 2023 20:28:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231126025510.28147-1-pc@manguebit.com>
In-Reply-To: <20231126025510.28147-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 26 Nov 2023 22:28:42 -0600
Message-ID: <CAH2r5mttTq-JhMVa7uMheJ8gmm9dJjMSCjhAWczuA5yUR4Tr2Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] reparse points work
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged to cifs-2.6.git for-next pending more testing and review

rearranged order slightly to move patch 9 up (and added Cc: stable to that =
one)

On Sat, Nov 25, 2023 at 8:55=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Hi Steve,
>
> This series contains reparse point fixes and improvements for SMB2+:
>
> - Add support for creating character/block devices, sockets and fifos
>   via NFS reparse points by default.
>
> - Add support for creating SMB symlinks via IO_REPARSE_TAG_SYMLINK
>   reparse points.
>
> - smb2_compound_op()
>
>   * allow up to MAX_COMPOUND(5) commands in a single compound request
>   * introduce SMB2_OP_{GET,SET}_REPARSE commands
>
> - Optimisations for dentry revalidation and read/write of reparse
>   points by reducing number of roundtrips.
>
> - Fix renaming and hardlinking of reparse points
>
> For people who pass 'mfsymlinks' and 'sfu' mount options, the
> implementation is expected to avoid creating reparse points at all.
>
> Volker Lendecke had suggested trying to create both SMB symlink and
> mfsymlink in a single compound request but this series doesn't have
> it.  It could be implemented later.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
> Changes in v2:
> - Fix missing mode bits for SMB symlinks (reported by Steve)
> - Fix uninitialised var warnings (reported by kernel test robot)
> - Add dentry reval optimisation for SMB3 POSIX query info as well
>
> ---
> Paulo Alcantara (9):
>   smb: client: extend smb2_compound_op() to accept more commands
>   smb: client: allow creating special files via reparse points
>   smb: client: allow creating symlinks via reparse points
>   smb: client: optimise reparse point querying
>   smb: client: fix renaming of reparse points
>   smb: client: fix hardlinking of reparse points
>   smb: client: cleanup smb2_query_reparse_point()
>   smb: client: optimise dentry revalidation for reparse points
>   smb: client: fix missing mode bits for SMB symlinks
>
>  fs/smb/client/cifsglob.h  |   47 +-
>  fs/smb/client/cifsproto.h |   30 +-
>  fs/smb/client/cifssmb.c   |   17 +-
>  fs/smb/client/dir.c       |    7 +-
>  fs/smb/client/file.c      |   10 +-
>  fs/smb/client/inode.c     |   98 ++--
>  fs/smb/client/link.c      |   29 +-
>  fs/smb/client/smb2glob.h  |   26 +-
>  fs/smb/client/smb2inode.c | 1054 ++++++++++++++++++++++---------------
>  fs/smb/client/smb2ops.c   |  297 ++++++-----
>  fs/smb/client/smb2proto.h |   29 +-
>  fs/smb/client/trace.h     |    7 +-
>  12 files changed, 997 insertions(+), 654 deletions(-)
>
> --
> 2.43.0
>


--=20
Thanks,

Steve
