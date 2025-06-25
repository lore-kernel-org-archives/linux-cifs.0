Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B6A2D5C81;
	Wed, 25 Jun 2025 16:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750869406; cv=none; b=bymdCWTMF+C8z1yHgW23N1cqoSorPJCyudxVjO1mhRpERj2z6cAMKEm11j44yg7t5t/xrsbGSvXa6rLqrYzaD4a/nbjwuXN089BC1DpXvGzSEIYyRPpL1bTr7jagawRBJwa0Ezz73nPM0kBoMNseWZTGMVNQvxSa2/0bf04jniA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750869406; c=relaxed/simple;
	bh=QFsZkGHsds4aKU3W+HBMep6Wa8OA2D4Tk7bnZGd2jWU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XGyB/MhH8oGLvofzbLawAhGmJ5DgzoYxqO41c96M/U4ODIleGHSlMyyewjXBbQmpM5W5vsMcuNENl5qP5YGZiuwGwQmdiYSsVScy+csNAOezHAl6zgXVSzyekf2Rk0rR+hhUSRsVDz1IBaHs5iO13NDZAd17G9tZlkN5ZJ1qJPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gJmOp1Ak; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gJmOp1Ak"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6faf66905baso1914926d6.2;
        Wed, 25 Jun 2025 09:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750869404; x=1751474204; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4d9eApCSSyTMpsriaBERHWJd5ehcOhQ7ctWFZ18Hr7E=;
        b=gJmOp1AkqDJhQQ2KrS6+B46wcnFnmxzfE4aEI4uCtM65vwuP7B7QV4yopKbt738l8H
         oX4G1CPi6tv9zIhXxC7zd15CWeO9C3BAJub3CZJEuIDRJLLL93dt30+u/u0in3LsgwcA
         A2LTaiUyY4M8YLbTBMSmVkW6L3FTGbHrQnK3BWmF+2FVLShe5bSQWTKjDl0sk/6K0Wfa
         SNsytCnOms3zvhl3df/ADrI+y2vOsx1FZYVeSe0ufkfugmFKFIvM0simKpj8zAsRk9xM
         hyXmOrXTk9LDCZU3Alp6QcB8j7DLP9mwvsZ2KFCi/LboS6SCgX6OPqpYmHvAkJdUNIo2
         jJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750869404; x=1751474204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4d9eApCSSyTMpsriaBERHWJd5ehcOhQ7ctWFZ18Hr7E=;
        b=DZab4fBNiQrezajEmRbmtKbjjJrQi7LsE/bPzrTElkBZaUcvldPmoucZxSbiZhRr4O
         b7sB4km1GJfsxNRb6yFowJ27Xo1N2W4vLqRZIXdFXIP3/51PMl25EK5QeJ6rCMNgbfHA
         sL/GAC17XWwkln9mHqSKfCtZjGC5LcK8gSKlZQvGxRdG7CJRuj/IwxEGZcZAYveikca6
         gzrhzIswhW4WWY2HDZkWZpRllfulhiDQlE5CkgVasFxajLt0cRyKmc4X4X7PMtJ9JMdU
         0FedrLhvvGko00v3j/9rnzF07ZDpSTR1/5KKNO8nohWpVxothMigP62a3pNJCde7YI/J
         HZ9w==
X-Forwarded-Encrypted: i=1; AJvYcCWkDY6SEbZqZV364DcDANDdniw+Ap34bRlIPru91bxYTRZg3eBE8N93JBPCl8m5R++Lk/CbM78=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRq7pznkKK5b6hA+5d1wtbzonZ73HSgwC23gqdcYjA/gBTP4Z0
	KVWIraekYL12AIMhcU4HnQCxK+GGvLaNhf+44ETCzNrusPr3e2F2BE+j/+fJHzSElTsdYxBqsQb
	tb1gjmhAhzdQ8L5uqp1eeAApjrFDL8U05FA==
X-Gm-Gg: ASbGnctZ3w1YCvo7kRsyJCqDJpn4syvX2jLlUjwG8jS+buygu/wsTpuGb9LEZvnjF0v
	wGWPe3moY+Ul/Qoh1j/VNFwCQt1VLkiuFBmbDABNR4822E1GS02OgT0kyBZ8v78aQszhkRSTz7j
	9Cv+025g44d1axIQ9ZMXNt6rC4USU5nwOSx+YP5cvY0AnTnn3jgTcYAtJg5vZMUsIkUvycPoSI2
	jGH
X-Google-Smtp-Source: AGHT+IEk46fsNFposX423Xj2Z+1uZPrg6VxLruQLBSrEiFJLXmPSmYqDqtmOXEgpHTb3w5yESy0n+EU6eN/yGGGIa18=
X-Received: by 2002:a05:6214:21ef:b0:6fa:c6e6:11f9 with SMTP id
 6a1803df08f44-6fd5ef63fc4mr50324086d6.11.1750869403480; Wed, 25 Jun 2025
 09:36:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250625081304.943870-1-metze@samba.org>
In-Reply-To: <20250625081304.943870-1-metze@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 25 Jun 2025 11:36:32 -0500
X-Gm-Features: Ac12FXxJPsW3fhoWlvY2DNNrJGlkQXu3lWP0Kd-NJ0k1OK9ZSs6jde4_rsqeWg8
Message-ID: <CAH2r5mvewQhsrpVaj=2oyTjNT1WWTGr0FoN6PikKOqUqi5MCHw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: remove \t from TP_printk statements
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Wed, Jun 25, 2025 at 3:13=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> The generate '[FAILED TO PARSE]' strings in trace-cmd report output like =
this:
>
>   rm-5298  [001]  6084.533748493: smb3_exit_err:        [FAILED TO PARSE]=
 xid=3D972 func_name=3Dcifs_rmdir rc=3D-39
>   rm-5298  [001]  6084.533959234: smb3_enter:           [FAILED TO PARSE]=
 xid=3D973 func_name=3Dcifs_closedir
>   rm-5298  [001]  6084.533967630: smb3_close_enter:     [FAILED TO PARSE]=
 xid=3D973 fid=3D94489281833 tid=3D1 sesid=3D96758029877361
>   rm-5298  [001]  6084.534004008: smb3_cmd_enter:       [FAILED TO PARSE]=
 tid=3D1 sesid=3D96758029877361 cmd=3D6 mid=3D566
>   rm-5298  [001]  6084.552248232: smb3_cmd_done:        [FAILED TO PARSE]=
 tid=3D1 sesid=3D96758029877361 cmd=3D6 mid=3D566
>   rm-5298  [001]  6084.552280542: smb3_close_done:      [FAILED TO PARSE]=
 xid=3D973 fid=3D94489281833 tid=3D1 sesid=3D96758029877361
>   rm-5298  [001]  6084.552316034: smb3_exit_done:       [FAILED TO PARSE]=
 xid=3D973 func_name=3Dcifs_closedir
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>  fs/smb/client/trace.h | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
> index 52bcb55d9952..93e5b2bb9f28 100644
> --- a/fs/smb/client/trace.h
> +++ b/fs/smb/client/trace.h
> @@ -140,7 +140,7 @@ DECLARE_EVENT_CLASS(smb3_rw_err_class,
>                 __entry->len =3D len;
>                 __entry->rc =3D rc;
>         ),
> -       TP_printk("\tR=3D%08x[%x] xid=3D%u sid=3D0x%llx tid=3D0x%x fid=3D=
0x%llx offset=3D0x%llx len=3D0x%x rc=3D%d",
> +       TP_printk("R=3D%08x[%x] xid=3D%u sid=3D0x%llx tid=3D0x%x fid=3D0x=
%llx offset=3D0x%llx len=3D0x%x rc=3D%d",
>                   __entry->rreq_debug_id, __entry->rreq_debug_index,
>                   __entry->xid, __entry->sesid, __entry->tid, __entry->fi=
d,
>                   __entry->offset, __entry->len, __entry->rc)
> @@ -190,7 +190,7 @@ DECLARE_EVENT_CLASS(smb3_other_err_class,
>                 __entry->len =3D len;
>                 __entry->rc =3D rc;
>         ),
> -       TP_printk("\txid=3D%u sid=3D0x%llx tid=3D0x%x fid=3D0x%llx offset=
=3D0x%llx len=3D0x%x rc=3D%d",
> +       TP_printk("xid=3D%u sid=3D0x%llx tid=3D0x%x fid=3D0x%llx offset=
=3D0x%llx len=3D0x%x rc=3D%d",
>                 __entry->xid, __entry->sesid, __entry->tid, __entry->fid,
>                 __entry->offset, __entry->len, __entry->rc)
>  )
> @@ -247,7 +247,7 @@ DECLARE_EVENT_CLASS(smb3_copy_range_err_class,
>                 __entry->len =3D len;
>                 __entry->rc =3D rc;
>         ),
> -       TP_printk("\txid=3D%u sid=3D0x%llx tid=3D0x%x source fid=3D0x%llx=
 source offset=3D0x%llx target fid=3D0x%llx target offset=3D0x%llx len=3D0x=
%x rc=3D%d",
> +       TP_printk("xid=3D%u sid=3D0x%llx tid=3D0x%x source fid=3D0x%llx s=
ource offset=3D0x%llx target fid=3D0x%llx target offset=3D0x%llx len=3D0x%x=
 rc=3D%d",
>                 __entry->xid, __entry->sesid, __entry->tid, __entry->targ=
et_fid,
>                 __entry->src_offset, __entry->target_fid, __entry->target=
_offset, __entry->len, __entry->rc)
>  )
> @@ -298,7 +298,7 @@ DECLARE_EVENT_CLASS(smb3_copy_range_done_class,
>                 __entry->target_offset =3D target_offset;
>                 __entry->len =3D len;
>         ),
> -       TP_printk("\txid=3D%u sid=3D0x%llx tid=3D0x%x source fid=3D0x%llx=
 source offset=3D0x%llx target fid=3D0x%llx target offset=3D0x%llx len=3D0x=
%x",
> +       TP_printk("xid=3D%u sid=3D0x%llx tid=3D0x%x source fid=3D0x%llx s=
ource offset=3D0x%llx target fid=3D0x%llx target offset=3D0x%llx len=3D0x%x=
",
>                 __entry->xid, __entry->sesid, __entry->tid, __entry->targ=
et_fid,
>                 __entry->src_offset, __entry->target_fid, __entry->target=
_offset, __entry->len)
>  )
> @@ -482,7 +482,7 @@ DECLARE_EVENT_CLASS(smb3_fd_class,
>                 __entry->tid =3D tid;
>                 __entry->sesid =3D sesid;
>         ),
> -       TP_printk("\txid=3D%u sid=3D0x%llx tid=3D0x%x fid=3D0x%llx",
> +       TP_printk("xid=3D%u sid=3D0x%llx tid=3D0x%x fid=3D0x%llx",
>                 __entry->xid, __entry->sesid, __entry->tid, __entry->fid)
>  )
>
> @@ -521,7 +521,7 @@ DECLARE_EVENT_CLASS(smb3_fd_err_class,
>                 __entry->sesid =3D sesid;
>                 __entry->rc =3D rc;
>         ),
> -       TP_printk("\txid=3D%u sid=3D0x%llx tid=3D0x%x fid=3D0x%llx rc=3D%=
d",
> +       TP_printk("xid=3D%u sid=3D0x%llx tid=3D0x%x fid=3D0x%llx rc=3D%d"=
,
>                 __entry->xid, __entry->sesid, __entry->tid, __entry->fid,
>                 __entry->rc)
>  )
> @@ -794,7 +794,7 @@ DECLARE_EVENT_CLASS(smb3_cmd_err_class,
>                 __entry->status =3D status;
>                 __entry->rc =3D rc;
>         ),
> -       TP_printk("\tsid=3D0x%llx tid=3D0x%x cmd=3D%u mid=3D%llu status=
=3D0x%x rc=3D%d",
> +       TP_printk("sid=3D0x%llx tid=3D0x%x cmd=3D%u mid=3D%llu status=3D0=
x%x rc=3D%d",
>                 __entry->sesid, __entry->tid, __entry->cmd, __entry->mid,
>                 __entry->status, __entry->rc)
>  )
> @@ -829,7 +829,7 @@ DECLARE_EVENT_CLASS(smb3_cmd_done_class,
>                 __entry->cmd =3D cmd;
>                 __entry->mid =3D mid;
>         ),
> -       TP_printk("\tsid=3D0x%llx tid=3D0x%x cmd=3D%u mid=3D%llu",
> +       TP_printk("sid=3D0x%llx tid=3D0x%x cmd=3D%u mid=3D%llu",
>                 __entry->sesid, __entry->tid,
>                 __entry->cmd, __entry->mid)
>  )
> @@ -867,7 +867,7 @@ DECLARE_EVENT_CLASS(smb3_mid_class,
>                 __entry->when_sent =3D when_sent;
>                 __entry->when_received =3D when_received;
>         ),
> -       TP_printk("\tcmd=3D%u mid=3D%llu pid=3D%u, when_sent=3D%lu when_r=
cv=3D%lu",
> +       TP_printk("cmd=3D%u mid=3D%llu pid=3D%u, when_sent=3D%lu when_rcv=
=3D%lu",
>                 __entry->cmd, __entry->mid, __entry->pid, __entry->when_s=
ent,
>                 __entry->when_received)
>  )
> @@ -898,7 +898,7 @@ DECLARE_EVENT_CLASS(smb3_exit_err_class,
>                 __assign_str(func_name);
>                 __entry->rc =3D rc;
>         ),
> -       TP_printk("\t%s: xid=3D%u rc=3D%d",
> +       TP_printk("%s: xid=3D%u rc=3D%d",
>                 __get_str(func_name), __entry->xid, __entry->rc)
>  )
>
> @@ -924,7 +924,7 @@ DECLARE_EVENT_CLASS(smb3_sync_err_class,
>                 __entry->ino =3D ino;
>                 __entry->rc =3D rc;
>         ),
> -       TP_printk("\tino=3D%lu rc=3D%d",
> +       TP_printk("ino=3D%lu rc=3D%d",
>                 __entry->ino, __entry->rc)
>  )
>
> @@ -950,7 +950,7 @@ DECLARE_EVENT_CLASS(smb3_enter_exit_class,
>                 __entry->xid =3D xid;
>                 __assign_str(func_name);
>         ),
> -       TP_printk("\t%s: xid=3D%u",
> +       TP_printk("%s: xid=3D%u",
>                 __get_str(func_name), __entry->xid)
>  )
>
> --
> 2.34.1
>
>


--=20
Thanks,

Steve
