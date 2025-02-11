Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3827921519B;
	Tue, 11 Feb 2025 15:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739287991; cv=none; b=eO+uUCHLPO1+doReZiHzfGEoBsBBchq5UpazlA05tnPhQtABTI43SrM1j0uyKUj68xFoLX2cZu1A5094DT4SYe1tHXseLPpEbSs+g3snzmDj13vM5yUOmGH22lSb/4Hxf+LQUFa3FcLCBgUD0ToZ9IQIPcNFbHkQY+49RJ2NSjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739287991; c=relaxed/simple;
	bh=4hjONu/yenN50aobRO7NENZ/gqyfkVKScYEQss9zh6A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dlQt+dNF/pLEsbFg/EuIHkfLHCkqqApKyeERh/kDSiF+T0ENgbBKawRS6Msfj3T1RYhVDsQUd/d5r/u4DzUrvkjCCLACVAAzMnHwC+aRPCfoqbabSZJQhLcT/PEsZL3TQt3A2leCDE8rlW1PIN+FtpiLSLVlRo/eeL3LRHgnLRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W0sHqhEZ; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W0sHqhEZ"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-54504f29000so3255909e87.1;
        Tue, 11 Feb 2025 07:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739287987; x=1739892787; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IaEvFrq14LMWLY6QHMZeCXuFDnnim6xe6YSRAsu6L5M=;
        b=W0sHqhEZKegWmrZ4iVSUfG4Q4Fv1MxAxrVh2LSUvjaS/cRPAKd+YquYFdmW+C90EDg
         81L9HKSUuwf4s8HyQRHGnw6HDzOL50MS4fSC6NJBsvJ36tzY0SPprtrMChRt+LTe9wz4
         uZo0MRYU1CSKDjrMpR1OskyX8Oc43Fil5Bi+7w+7m184gaXczR9KGLmeGLi9JUsOzJDy
         hDj/RQGOmnuGO+l3E0PJ+NzHh+EnhpEa3hv1GS5kNvLZ+7WcmpiR64A8FST2kuO7AskB
         ismSeE6ZeVZ/ylZRnbDXwX6SYfK4oaM1TWKGSSkeQBTFKfR532EMY3c0WoQs/U4JNZf/
         HWLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739287987; x=1739892787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IaEvFrq14LMWLY6QHMZeCXuFDnnim6xe6YSRAsu6L5M=;
        b=Vbt0DsPB0GusmjWODj2Y2g0tfxkupADNaWhd+bKIkoiFBj8OPhhbog2HpSF6WK7emD
         yERafVka+E014b6NDGQsOVI9Hy9X+NINGCuR5YN9M4DQEUW4Qxn2TiC1dvkACv9ta5ye
         lVYpsDPZvO6hf91mViT+cXEHDBlemf7/q8lyOdfKl4NwJtrJGsZq1t6TWmWUqp/ZQuUN
         KV9RkmPOQPN46Jj/KS7csLmfthY8rAb/G4dnvwDou0biVBXyMNBmksSWGosJVWx5iNUE
         GSx00Etpi/CZ/ypz70mBnOxbkN7/leTQ0XfI/F2v2jKVDObXPUo/cLXMJQ+jVb13HFPU
         nZfA==
X-Forwarded-Encrypted: i=1; AJvYcCXGjhfv5mL3my4nwJZd3uAWHLWBPL5ckP2DMeT+ysXB5jyiiS6z45AdBHgXFDcaYQBZ26bN4HM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywa5KC8W3shH2N6g2Zp6XeaNRLlmds3+mH0EyXy/H35PN8X3wU1
	jvZw/qJWSsqs0XHKNaxgfbsCYYTXcLIdVORUgwopkIomBE1WscrZUPJgkSTurbCWIHVG2C8udlO
	iOkmi8xciSrgCPghIGSML4Sdplyo=
X-Gm-Gg: ASbGncuMhfjSJ0nWfEeDknvG9w5NYNBtk2HXQ88sWifPoe9q4SDdRcGqSzHgNGxRHy+
	7VmzWxHeT2cz52i4nqi3/SEeUuZDw3y9MgYBAMuJ9tfNfQSNFLOBjoqNpxBibT/MbP3bu/ecH1w
	==
X-Google-Smtp-Source: AGHT+IEnnDnZpFhALT9qFXSQoBtLgQV+4mvtu14AYBZjzgeyBvpkjn4tzWPW2NVrNOGiGBwqjZmWDEiOXwBTHSyGiOg=
X-Received: by 2002:a05:6512:3ba5:b0:542:29b6:9c26 with SMTP id
 2adb3069b0e04-54511876841mr1468860e87.47.1739287986743; Tue, 11 Feb 2025
 07:33:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211100053.9485-1-sprasad@microsoft.com>
In-Reply-To: <20250211100053.9485-1-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 11 Feb 2025 09:32:55 -0600
X-Gm-Features: AWEUYZmrdE2rLwikWZsCPxrpGj7xJqVGUPaHjF-c3rxdudhLbDMcMhQPa8kyNXo
Message-ID: <CAH2r5mu5RBaqUKQs-UH-jDWgmAdosSV31wo=8oUSePPdmr6_Hg@mail.gmail.com>
Subject: Re: [PATCH] cifs: pick channels for individual subrequests
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	tom@talpey.com, dhowells@redhat.com, Shyam Prasad N <sprasad@microsoft.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged to cifs-2.6.git for-next pending more testing/review

On Tue, Feb 11, 2025 at 4:01=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> The netfs library could break down a read request into
> multiple subrequests. When multichannel is used, there is
> potential to improve performance when each of these
> subrequests pick a different channel.
>
> Today we call cifs_pick_channel when the main read request
> is initialized in cifs_init_request. This change moves this to
> cifs_prepare_read, which is the right place to pick channel since
> it gets called for each subrequest.
>
> Interestingly cifs_prepare_write already does channel selection
> for individual subreq, but looks like it was missed for read.
> This is especially important when multichannel is used with
> increased rasize.
>
> In my test setup, with rasize set to 8MB, a sequential read
> of large file was taking 11.5s without this change. With the
> change, it completed in 9s. The difference is even more signigicant
> with bigger rasize.
>
> Cc: <stable@vger.kernel.org>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsglob.h | 1 -
>  fs/smb/client/file.c     | 7 ++++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index a68434ad744a..243e4881528c 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1508,7 +1508,6 @@ struct cifs_io_parms {
>  struct cifs_io_request {
>         struct netfs_io_request         rreq;
>         struct cifsFileInfo             *cfile;
> -       struct TCP_Server_Info          *server;
>         pid_t                           pid;
>  };
>
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 79de2f2f9c41..8582cf61242c 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -147,7 +147,7 @@ static int cifs_prepare_read(struct netfs_io_subreque=
st *subreq)
>         struct netfs_io_request *rreq =3D subreq->rreq;
>         struct cifs_io_subrequest *rdata =3D container_of(subreq, struct =
cifs_io_subrequest, subreq);
>         struct cifs_io_request *req =3D container_of(subreq->rreq, struct=
 cifs_io_request, rreq);
> -       struct TCP_Server_Info *server =3D req->server;
> +       struct TCP_Server_Info *server;
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(rreq->inode->i_sb);
>         size_t size;
>         int rc =3D 0;
> @@ -156,6 +156,8 @@ static int cifs_prepare_read(struct netfs_io_subreque=
st *subreq)
>                 rdata->xid =3D get_xid();
>                 rdata->have_xid =3D true;
>         }
> +
> +       server =3D cifs_pick_channel(tlink_tcon(req->cfile->tlink)->ses);
>         rdata->server =3D server;
>
>         if (cifs_sb->ctx->rsize =3D=3D 0)
> @@ -198,7 +200,7 @@ static void cifs_issue_read(struct netfs_io_subreques=
t *subreq)
>         struct netfs_io_request *rreq =3D subreq->rreq;
>         struct cifs_io_subrequest *rdata =3D container_of(subreq, struct =
cifs_io_subrequest, subreq);
>         struct cifs_io_request *req =3D container_of(subreq->rreq, struct=
 cifs_io_request, rreq);
> -       struct TCP_Server_Info *server =3D req->server;
> +       struct TCP_Server_Info *server =3D rdata->server;
>         int rc =3D 0;
>
>         cifs_dbg(FYI, "%s: op=3D%08x[%x] mapping=3D%p len=3D%zu/%zu\n",
> @@ -266,7 +268,6 @@ static int cifs_init_request(struct netfs_io_request =
*rreq, struct file *file)
>                 open_file =3D file->private_data;
>                 rreq->netfs_priv =3D file->private_data;
>                 req->cfile =3D cifsFileInfo_get(open_file);
> -               req->server =3D cifs_pick_channel(tlink_tcon(req->cfile->=
tlink)->ses);
>                 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
>                         req->pid =3D req->cfile->pid;
>         } else if (rreq->origin !=3D NETFS_WRITEBACK) {
> --
> 2.43.0
>


--=20
Thanks,

Steve
