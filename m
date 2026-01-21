Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A94322740
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 01:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768960598; cv=pass; b=WGCp9qvBiguWc+rOC1X+FAmPZ25zu4dIc1EFTwV6QEt5f5fY9yemyqJGyrQ2z+hGRc+JHtTHx17SgWu8tMon58e1WzLMPaAs4ldiHm9wCqJSDI4Rz8mcVgUlv4M5tlxWiTVt/rlTI1cmflk6fDXTeSG8vh85ot0WsWNbSBYHDAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768960598; c=relaxed/simple;
	bh=PtPJQoJjlR8BhX4rjc0PQCOPHpTXa743IIefkYNiXKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RjiTjxdG2M/CbPedn/n9cjiPpPizemw+SlyA7W9ekFqVINhsMpuYmaa1hlZeQTJJKKxfaEBx0mUSKVCIgsEB9nldg5r2emqEgt+6B/cNtBe5F6sShz7Fx1aUoRRSNlCxNatpXsBslZid1y9NSuo4fVWHrl/ZcjtznjXTnCP0vm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gKzdIjDs; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gKzdIjDs"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8947404b367so197516d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 17:56:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768960591; cv=none;
        d=google.com; s=arc-20240605;
        b=C87v+RHGq3jjZCsFlUp9vCGVq8Ln1Y5FPNEvqQDeq+mj0gEdKcjZzQYFETm21p5OkA
         Cclx9cSROK2EPvE0PRWKUTUIlWW7S1UAvRifBMu6b95bllo0vNNY051GwL9riy27k4Ph
         SLo5ikNXBnAD4PEdY7n4UOlaCWQGcDAWBdexgm3y49fzXdF0tx4Gxlk1U/E3ZjqCd1Y7
         2bdCqUPIwXOWdrrtF9PT2R+hddhumjXpWjwTqRytFfWBkvljOWc86SfiV+yiNPZLweVX
         qNQWoThFFrf4Mm6kg/a5miEJzJa/iiB+2PN5kUBSK9DVkrEK58oMFL4GD3JZC6vflP5p
         fxqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nLy2EP1yx4hIMGWJbxaR9pbSHuAIT7JpiqEMNYeEnIk=;
        fh=OdhT+T13QK1EojNw3UsXCIcUfSnNW/8kq68KIZZtM1k=;
        b=K+X8eNQDrEAhyTYZEzSeOjpTBqqqYASrxC3ZbDsLBsZIZ1SP1MgbEqvh2Viqc4feAT
         FEhE2dgE3NTEPnLYcBxsPGg4M4V5zemFHBcgJ/oyZPGTcp/Faefm4K0QizAznT7UQre+
         yZilP2GMtuuMq/9j5Sq/TOpe74L7U3aO/Tp55McA5nCvBRTBmXWH4TMcrVac3OJDDbI0
         Al5WSbVYAqWVNYBo/45+HjfI9jIIiJ/nnTOO4e9iovQGf5Hy6HFDVB434tTf6e/YeSu2
         jhNrXWz//H83mrG5nYWlK/0Da/Hz4Qzd1pp7BsRhKyZkFjjiiypntSNcrBJTOoWASpKi
         G+5w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768960591; x=1769565391; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nLy2EP1yx4hIMGWJbxaR9pbSHuAIT7JpiqEMNYeEnIk=;
        b=gKzdIjDsNnXzFS3Kd3INXXIP5NQGfOrAUIFYhYsf69G9vVdjSc8PyNJWBY8C0NK9Yx
         1FSaP+mlnjcyB8Wt0Wpyi0RUGwamHJOJNcqvjtUyt8+bjTeTZ1rP6Uf2cV0cdXlH3Qiy
         VGs1S91PUpJcX7+JLbWzz3EtFPf+aTx4HgaIhYgIC+HxiB1n0SRBuU3j+xqd7SJbcTH+
         qseTJrZVtN8E+9HTr0b5q52V17Qx5NDOqX8Av78kMAeewzDXwJZBQ/oD8xO/5zToaxGe
         DXjLXKwigYBXprbnWFe500SyuZQqLj054toHNU/ZQqgRlvyidncfGMayTq4qaFCdMpBh
         GTYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768960591; x=1769565391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nLy2EP1yx4hIMGWJbxaR9pbSHuAIT7JpiqEMNYeEnIk=;
        b=YzrIDMwszuutULbemMMq/cSPsqR8I6IL/j/WMP2FWJ8+OYJh5mjuYEZU/UGLyU52wW
         7+rCZL+bucYnIhMw7OoyAqeagE9oH0G6vtAVeli9HyprZBqok/btkph5goy+8Z1Cvd9I
         JoS7kXv+8O4hKPLqSSDbvUTFFCyQu5RQU5KfpGDKAesfhmIu9vtTV9RGsgRRv63+JYn1
         LMgmYW/pMmGzw3+lEdi+JuaI3mVQQ4EuJ45DZK7vDRx2P+GKFXVnwlw93NUA6WF3/fGZ
         9YQNebgfcv+Pd1ylodcBKpp3PF1vYUjVXIRB9Mo8qcbc42r19ASS+NrHaZj1Ej4f3eeN
         zfVw==
X-Gm-Message-State: AOJu0YxAdSmh3RuwdkCgQqI6YA3lAYKtB6Jg4xO1IEztxlieoWV/1o0c
	jX0X6gBFr/u95iBwsYGVSSxLCKjYlIixGUrByr4yKHRGJKDofvRDjYWbzxpG/Dy+pRlKi6rnVNZ
	5NWZrG2oQ49LUdp/JRNuUq9x8mCxgb4c=
X-Gm-Gg: AZuq6aLyWTD749MQSxUoOmCbqUWzM8Lx1+1nGXx3gN3HvkOX/dxveNJww6QoTq5VmlZ
	Kiih9qhxveKMCme1pk0KCapnMp4pYRGqsqk5hWH3ic2R4uS2VnLA1C4foZxzJ8eGJEAPi5dDOH5
	4XiHGE8HWUDz3yyqHGaWraZRBeoNMh1wxoaNKvcxu7iz1dg51CenLPC9yj4Jabf15pUTvQ66DVd
	3nx7qZl203W7pdS+IoIHH8jkdi7vAQptnO6pGkrhFOjYb6PWMtWIkM/V++unrpLUDYaX8+UNqn4
	idLQ1na9DG7NbS7DhIn9TjU50eyJfurNvs1G657ykDG1qarnfwbI97ognQJAwnaLZTfiupcNhB4
	Ghmsh8108P2rG9sCxOZ0QiE/TiIZIr4mLGVqXKnBBh/ff514V+bjTtc/Hs2OYPjW5edz11q/+t5
	MiD/ODmSwY
X-Received: by 2002:ad4:5f46:0:b0:894:6901:cb3e with SMTP id
 6a1803df08f44-8946901d26dmr55437146d6.19.1768960590554; Tue, 20 Jan 2026
 17:56:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120062152.628822-1-sprasad@microsoft.com> <20260120062152.628822-4-sprasad@microsoft.com>
In-Reply-To: <20260120062152.628822-4-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 20 Jan 2026 19:56:19 -0600
X-Gm-Features: AZwV_QgtUOOUzfE3x4txi3s6zQeY9qdHqwETAAOZrbcxKNF0LFCGaVFlWGwOrVs
Message-ID: <CAH2r5mvKYsepPBqi8f0P6KXZBuov4L6EdCx9vac7u7t7e953qQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] cifs: make retry logic in read/write path consistent
 with other paths
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	dhowells@redhat.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Checkpatch flagged this with minor warning. Let me know if you do
updated version of it

0004-cifs-make-retry-logic-in-read-write-path-consistent-.patch
------------------------------------------------------------------------
WARNING: else is not generally useful after a break or return
#64: FILE: fs/smb/client/smb2pdu.c:4629:
+ break;
+ } else

total: 0 errors, 1 warnings, 138 lines checked

On Tue, Jan 20, 2026 at 12:22=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Today in most other code paths in cifs.ko, the decision of whether
> to retry a command depends on two mount options: retrans and hard.
> However, the read/write code paths diverged from this and would only
> retry if the error returned was -EAGAIN. However, there are other
> replayable errors in cifs.ko, for which is_replayable_errors helper
> was written. This change makes read/write codepaths consistent with
> other code-paths.
>
> This change also does the following:
> 1. The SMB2 read/write code diverged significantly (presumably since
> they were changed during netfs refactor at different times). This
> changes the response verification logic to be consistent.
> 2. Moves the netfs tracepoints to slightly different locations in order
> to make debugging easier.
>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsglob.h |  2 ++
>  fs/smb/client/smb2pdu.c  | 70 +++++++++++++++++++++++++++++++---------
>  2 files changed, 56 insertions(+), 16 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 3eca5bfb70303..f6ebd3fd176d7 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1507,6 +1507,8 @@ struct cifs_io_subrequest {
>         int                             result;
>         bool                            have_xid;
>         bool                            replay;
> +       unsigned int                    retries;        /* number of retr=
ies so far */
> +       unsigned int                    cur_sleep;      /* time to sleep =
before replay */
>         struct kvec                     iov[2];
>         struct TCP_Server_Info          *server;
>  #ifdef CONFIG_CIFS_SMB_DIRECT
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 5d57c895ca37a..89f728392a734 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -4616,17 +4616,19 @@ smb2_readv_callback(struct TCP_Server_Info *serve=
r, struct mid_q_entry *mid)
>         case MID_RESPONSE_RECEIVED:
>                 credits.value =3D le16_to_cpu(shdr->CreditRequest);
>                 credits.instance =3D server->reconnect_instance;
> -               /* result already set, check signature */
> -               if (server->sign && !mid->decrypted) {
> -                       int rc;
> +               rdata->result =3D smb2_check_receive(mid, server, 0);
> +               if (rdata->result !=3D 0) {
> +                       rdata->subreq.error =3D rdata->result;
> +                       if (is_replayable_error(rdata->result)) {
> +                               trace_netfs_sreq(&rdata->subreq, netfs_sr=
eq_trace_io_req_submitted);
> +                               __set_bit(NETFS_SREQ_NEED_RETRY, &rdata->=
subreq.flags);
> +                       } else {
> +                               trace_netfs_sreq(&rdata->subreq, netfs_sr=
eq_trace_io_bad);
> +                       }
> +                       break;
> +               } else
> +                       trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace=
_io_progress);
>
> -                       iov_iter_truncate(&rqst.rq_iter, rdata->got_bytes=
);
> -                       rc =3D smb2_verify_signature(&rqst, server);
> -                       if (rc)
> -                               cifs_tcon_dbg(VFS, "SMB signature verific=
ation returned error =3D %d\n",
> -                                        rc);
> -               }
> -               /* FIXME: should this be counted toward the initiating ta=
sk? */
>                 task_io_account_read(rdata->got_bytes);
>                 cifs_stats_bytes_read(tcon, rdata->got_bytes);
>                 break;
> @@ -4748,7 +4750,7 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
>         rc =3D smb2_new_read_req(
>                 (void **) &buf, &total_len, &io_parms, rdata, 0, 0);
>         if (rc)
> -               return rc;
> +               goto out;
>
>         if (smb3_encryption_required(io_parms.tcon))
>                 flags |=3D CIFS_TRANSFORM_REQ;
> @@ -4795,6 +4797,17 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
>
>  async_readv_out:
>         cifs_small_buf_release(buf);
> +
> +out:
> +       /* if the send error is retryable, let netfs know about it */
> +       if (is_replayable_error(rc) &&
> +           smb2_should_replay(tcon,
> +                              &rdata->retries,
> +                              &rdata->cur_sleep)) {
> +               trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_retr=
y_needed);
> +               __set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
> +       }
> +
>         return rc;
>  }
>
> @@ -4908,14 +4921,20 @@ smb2_writev_callback(struct TCP_Server_Info *serv=
er, struct mid_q_entry *mid)
>
>         switch (mid->mid_state) {
>         case MID_RESPONSE_RECEIVED:
> -               trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_prog=
ress);
>                 credits.value =3D le16_to_cpu(rsp->hdr.CreditRequest);
>                 credits.instance =3D server->reconnect_instance;
>                 result =3D smb2_check_receive(mid, server, 0);
>                 if (result !=3D 0) {
> -                       trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace=
_io_bad);
> +                       if (is_replayable_error(result)) {
> +                               trace_netfs_sreq(&wdata->subreq, netfs_sr=
eq_trace_io_req_submitted);
> +                               __set_bit(NETFS_SREQ_NEED_RETRY, &wdata->=
subreq.flags);
> +                       } else {
> +                               wdata->subreq.error =3D result;
> +                               trace_netfs_sreq(&wdata->subreq, netfs_sr=
eq_trace_io_bad);
> +                       }
>                         break;
> -               }
> +               } else
> +                       trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace=
_io_progress);
>
>                 written =3D le32_to_cpu(rsp->DataLength);
>                 /*
> @@ -4930,7 +4949,7 @@ smb2_writev_callback(struct TCP_Server_Info *server=
, struct mid_q_entry *mid)
>                 cifs_stats_bytes_written(tcon, written);
>
>                 if (written < wdata->subreq.len) {
> -                       wdata->result =3D -ENOSPC;
> +                       result =3D -ENOSPC;
>                 } else if (written > 0) {
>                         wdata->subreq.len =3D written;
>                         __set_bit(NETFS_SREQ_MADE_PROGRESS, &wdata->subre=
q.flags);
> @@ -4972,6 +4991,7 @@ smb2_writev_callback(struct TCP_Server_Info *server=
, struct mid_q_entry *mid)
>         }
>  #endif
>         if (result) {
> +               wdata->result =3D result;
>                 cifs_stats_fail_inc(tcon, SMB2_WRITE_HE);
>                 trace_smb3_write_err(wdata->rreq->debug_id,
>                                      wdata->subreq.debug_index,
> @@ -4994,6 +5014,14 @@ smb2_writev_callback(struct TCP_Server_Info *serve=
r, struct mid_q_entry *mid)
>                               server->credits, server->in_flight,
>                               0, cifs_trace_rw_credits_write_response_cle=
ar);
>         wdata->credits.value =3D 0;
> +
> +       /* see if we need to retry */
> +       if (is_replayable_error(wdata->result) &&
> +           smb2_should_replay(tcon,
> +                              &wdata->retries,
> +                              &wdata->cur_sleep))
> +               wdata->replay =3D true;
> +
>         cifs_write_subrequest_terminated(wdata, result ?: written);
>         release_mid(server, mid);
>         trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, 0,
> @@ -5112,7 +5140,7 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
>         }
>  #endif
>
> -       if (wdata->subreq.retry_count > 0)
> +       if (wdata->replay)
>                 smb2_set_replay(server, &rqst);
>
>         cifs_dbg(FYI, "async write at %llu %u bytes iter=3D%zx\n",
> @@ -5159,6 +5187,16 @@ smb2_async_writev(struct cifs_io_subrequest *wdata=
)
>  async_writev_out:
>         cifs_small_buf_release(req);
>  out:
> +       /* if the send error is retryable, let netfs know about it */
> +       if (is_replayable_error(rc) &&
> +           smb2_should_replay(tcon,
> +                              &wdata->retries,
> +                              &wdata->cur_sleep)) {
> +               wdata->replay =3D true;
> +               trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_retr=
y_needed);
> +               __set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
> +       }
> +
>         if (rc) {
>                 trace_smb3_rw_credits(wdata->rreq->debug_id,
>                                       wdata->subreq.debug_index,
> --
> 2.43.0
>


--=20
Thanks,

Steve
