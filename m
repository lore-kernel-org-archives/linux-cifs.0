Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C73329378
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 04:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768970780; cv=pass; b=Bqiz7vJkKocaT8G6YgZil2o3DtZurpIbdCw/sESOUuboSYCwT+d/DVKCb+3N7pkOXNiO68oaWcLsB0pzGlHk2p/jse0W2OktuobJifia07LZ418r2/w1bmSghfwtgdtkl0h+LyU4nNwHTaZR2Q2bV+cg9bRj5tDYStoW/18Y/1I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768970780; c=relaxed/simple;
	bh=tJ1tsnFyg5/uSbAATL51hCVR13F0q3uOMS9E/Iswv68=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Abx/SiG0OHZ+dkWUzpL8G4AWAgTYWaq/j8/nF4yUWulL3do1zRAEcORexN2OVxUtlcN1uyt0gEyr4xYI8aLfjM6HPyxjZenhSw7ysoYRWJjSDEBCjENq50dRum41SvEKCH4awtIt4JOkn4YLV2QMj0I+HHD+T+QHcBCJ3xshMV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U5znAiHs; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U5znAiHs"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-658072a4e56so2377210a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 20:46:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768970776; cv=none;
        d=google.com; s=arc-20240605;
        b=McJkdrYEpV4GZmSxpzohXwxXOWR4f2nNzec9IAeGvz6v72JONQdm20+LtXk3rJd/vD
         I3kEcQmfnJ8Q8g3HkWg+07r/2F6k7zmQK8qaqca9zfeoyfZ1aatM/y47I6sj8iXwkBCB
         vTF4bvhIFlqJ6INyEJLgqaeheyltISPGtGNJO0rzVfpmjD5vutxDVDM8ESYrF4B/zs37
         5hSp37hHYCMhwaNaYMrEwQY9dvUgK/Wm+exYRRKEZfiCPCgyYdE7JYrpHRfY3EgFAX9Q
         J0tjQIV2e4CNzso3WUhcxWloGgo/pN+lXJbzPx8FGjuh8x9lmRVxAb8mjMX1QRPWZTKx
         5OJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=inFuWc3Vso60kcBd09IUR5CK0wb0W76w6o0BhvM17mo=;
        fh=RqTa0eh/O6oIjzxnOQBsiZlmbu9yuXjiRpUfV9QsEWU=;
        b=cyvaMYpY36s8WUcR3ra60emFbGtER3cm0kId7ESzBjnrTIQzawy59+nlpS37NC1mPy
         pyB5vknYjN5ku4K8WpBft9VJMewdMKpbuzDwQVW/lE4ZQRqUnrgMDl/G4tkR79arpUP/
         9VI4wxDW9xZ9wxlJLyHL6lBOWNIDIgUVPK9FXll7/bKIj1Nc2AZvqCSuDKZp2qn2OdCr
         iiUN7lAvkn6T9WTCnB4Ok1HfJXhUj2xUshIs9kq4e4xOSmjRji0evJQz8uhCO3k95Tmu
         0xoID8z/Cal1JJFY1ttGXS5q1yOraxabBtD70Ose95IcuwWKmpwJpsdBTH5AN7WD4N/x
         NeWA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768970776; x=1769575576; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=inFuWc3Vso60kcBd09IUR5CK0wb0W76w6o0BhvM17mo=;
        b=U5znAiHszD7YyRtJP1fEQcNV9QDJtk+Z95gsSb1OLTtqDr1KbXG21PaNlnAP7k/Syd
         xra1fdN/0jv4+IXzOU1kHKjwPgEg5Laa7K36nRQOI09OaJHDLLTGdtjYf8dRKCfBLc53
         Dx/LgkZyBP+asMjfAFPFpAD9f8T5P0OO2wKu10tq56/DVhax0UAsjFGpllpJlgMWJOmR
         AVKHf8cwlbq0BfAi6qvOU6ROdd8PdPNnZ0imsb5VrT0toJtg0LAPbltRc5MRQiiWPOLh
         WkXUrbhu5gdbbXXH/xVyQyR8CN4Wk+Mv0+vPEe4QQrUYYNHBRv+2v4yYyvL6oXDtaCEv
         k/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768970776; x=1769575576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=inFuWc3Vso60kcBd09IUR5CK0wb0W76w6o0BhvM17mo=;
        b=ASKBeD2v89/GUM5iIYJnGOoP/aVbPWbhxeFz0pdN7WuvuJtss/Pz6OQ3e/JNbvXnYf
         ynpd4L4CTRufgIbe8kmpwGJ29y9vDwK3WYjz8ZWLGEir+H8oIPZBL51rpWDpSkh8ZlS0
         m2RJST0pIRvQsiPXw6ZDKWf5+iyG86bDjgYBnCGLEx5aWTFMhJE5Rca19Bz7L16PkfXY
         fhQDaAWoZsSfN375R2sjF6DcAta3HGeM39Vr+6cJBQy64jGHhUpxIqcYUpK2/Bd1fSMC
         L6ZIjjfyfaqvAYOkPGqe1qIUZlSWE4xdeuLWxoGL1fS35iB/VuXalsoBFHWlISwTglHG
         ovgA==
X-Gm-Message-State: AOJu0Ywr38AW+QVHLWd9nsXXRafeK3PFxVvdEnKryAmJr8Hb2EKWCMMp
	86nxlA40/WjlIZOBMdT/WSDNmOHTZPv+G3YK40t65JyEe9KX0zYBthI6n/r+y5JJLMP8lDcWa4Y
	zrwPpI+P8oAzzdV2MYGMzu+crJc4d0Aw=
X-Gm-Gg: AY/fxX6skOWNZx+85Q+mppTYO0+tt0DUNzTdrPSBq6JV4n9NGS8c6VpT583p9hk2iqT
	f/E4m/0mc6W8FA3xDiiTxCb38feZOFKK2/9QBVd7MrBWJHxi7bCCdajSXzyn3UJ3WIWNuNBvP2k
	5rT9dFb22ICSPa03+N/8F/jPoO4Lo0VKR3QFcn4USNpxOZaXEEfZsaaLhaPA9ODD8EVMdlJ4Mgk
	HRl4Ux6ZHmV0UMuducaH7u6rvPDgfAfpUeUqbtSEHWhyU+6nuiw2uatEU08yRYK4731Qw==
X-Received: by 2002:a17:907:a41:b0:b86:f558:ecaa with SMTP id
 a640c23a62f3a-b8792dc7e5amr1611210566b.27.1768970776196; Tue, 20 Jan 2026
 20:46:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120062152.628822-1-sprasad@microsoft.com>
 <20260120062152.628822-4-sprasad@microsoft.com> <CAH2r5mvKYsepPBqi8f0P6KXZBuov4L6EdCx9vac7u7t7e953qQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvKYsepPBqi8f0P6KXZBuov4L6EdCx9vac7u7t7e953qQ@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Wed, 21 Jan 2026 10:16:04 +0530
X-Gm-Features: AZwV_QgOA1v6C6lQxCK5FctJE-2InQZugONitIE14Ank37_BDsLY_9f239baSNE
Message-ID: <CANT5p=qQ7Sxhiu5HAFqveM8sLvy2RG_gjC_zcuitxoeD5Er0-Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] cifs: make retry logic in read/write path consistent
 with other paths
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	dhowells@redhat.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2026 at 7:26=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> Checkpatch flagged this with minor warning. Let me know if you do
> updated version of it
>
> 0004-cifs-make-retry-logic-in-read-write-path-consistent-.patch
> ------------------------------------------------------------------------
> WARNING: else is not generally useful after a break or return
> #64: FILE: fs/smb/client/smb2pdu.c:4629:
> + break;
> + } else
>
> total: 0 errors, 1 warnings, 138 lines checked

I saw that too Steve. I'll submit a v2 patch for this.

>
> On Tue, Jan 20, 2026 at 12:22=E2=80=AFAM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > Today in most other code paths in cifs.ko, the decision of whether
> > to retry a command depends on two mount options: retrans and hard.
> > However, the read/write code paths diverged from this and would only
> > retry if the error returned was -EAGAIN. However, there are other
> > replayable errors in cifs.ko, for which is_replayable_errors helper
> > was written. This change makes read/write codepaths consistent with
> > other code-paths.
> >
> > This change also does the following:
> > 1. The SMB2 read/write code diverged significantly (presumably since
> > they were changed during netfs refactor at different times). This
> > changes the response verification logic to be consistent.
> > 2. Moves the netfs tracepoints to slightly different locations in order
> > to make debugging easier.
> >
> > Cc: David Howells <dhowells@redhat.com>
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/cifsglob.h |  2 ++
> >  fs/smb/client/smb2pdu.c  | 70 +++++++++++++++++++++++++++++++---------
> >  2 files changed, 56 insertions(+), 16 deletions(-)
> >
> > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > index 3eca5bfb70303..f6ebd3fd176d7 100644
> > --- a/fs/smb/client/cifsglob.h
> > +++ b/fs/smb/client/cifsglob.h
> > @@ -1507,6 +1507,8 @@ struct cifs_io_subrequest {
> >         int                             result;
> >         bool                            have_xid;
> >         bool                            replay;
> > +       unsigned int                    retries;        /* number of re=
tries so far */
> > +       unsigned int                    cur_sleep;      /* time to slee=
p before replay */
> >         struct kvec                     iov[2];
> >         struct TCP_Server_Info          *server;
> >  #ifdef CONFIG_CIFS_SMB_DIRECT
> > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > index 5d57c895ca37a..89f728392a734 100644
> > --- a/fs/smb/client/smb2pdu.c
> > +++ b/fs/smb/client/smb2pdu.c
> > @@ -4616,17 +4616,19 @@ smb2_readv_callback(struct TCP_Server_Info *ser=
ver, struct mid_q_entry *mid)
> >         case MID_RESPONSE_RECEIVED:
> >                 credits.value =3D le16_to_cpu(shdr->CreditRequest);
> >                 credits.instance =3D server->reconnect_instance;
> > -               /* result already set, check signature */
> > -               if (server->sign && !mid->decrypted) {
> > -                       int rc;
> > +               rdata->result =3D smb2_check_receive(mid, server, 0);
> > +               if (rdata->result !=3D 0) {
> > +                       rdata->subreq.error =3D rdata->result;
> > +                       if (is_replayable_error(rdata->result)) {
> > +                               trace_netfs_sreq(&rdata->subreq, netfs_=
sreq_trace_io_req_submitted);
> > +                               __set_bit(NETFS_SREQ_NEED_RETRY, &rdata=
->subreq.flags);
> > +                       } else {
> > +                               trace_netfs_sreq(&rdata->subreq, netfs_=
sreq_trace_io_bad);
> > +                       }
> > +                       break;
> > +               } else
> > +                       trace_netfs_sreq(&rdata->subreq, netfs_sreq_tra=
ce_io_progress);
> >
> > -                       iov_iter_truncate(&rqst.rq_iter, rdata->got_byt=
es);
> > -                       rc =3D smb2_verify_signature(&rqst, server);
> > -                       if (rc)
> > -                               cifs_tcon_dbg(VFS, "SMB signature verif=
ication returned error =3D %d\n",
> > -                                        rc);
> > -               }
> > -               /* FIXME: should this be counted toward the initiating =
task? */
> >                 task_io_account_read(rdata->got_bytes);
> >                 cifs_stats_bytes_read(tcon, rdata->got_bytes);
> >                 break;
> > @@ -4748,7 +4750,7 @@ smb2_async_readv(struct cifs_io_subrequest *rdata=
)
> >         rc =3D smb2_new_read_req(
> >                 (void **) &buf, &total_len, &io_parms, rdata, 0, 0);
> >         if (rc)
> > -               return rc;
> > +               goto out;
> >
> >         if (smb3_encryption_required(io_parms.tcon))
> >                 flags |=3D CIFS_TRANSFORM_REQ;
> > @@ -4795,6 +4797,17 @@ smb2_async_readv(struct cifs_io_subrequest *rdat=
a)
> >
> >  async_readv_out:
> >         cifs_small_buf_release(buf);
> > +
> > +out:
> > +       /* if the send error is retryable, let netfs know about it */
> > +       if (is_replayable_error(rc) &&
> > +           smb2_should_replay(tcon,
> > +                              &rdata->retries,
> > +                              &rdata->cur_sleep)) {
> > +               trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_re=
try_needed);
> > +               __set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
> > +       }
> > +
> >         return rc;
> >  }
> >
> > @@ -4908,14 +4921,20 @@ smb2_writev_callback(struct TCP_Server_Info *se=
rver, struct mid_q_entry *mid)
> >
> >         switch (mid->mid_state) {
> >         case MID_RESPONSE_RECEIVED:
> > -               trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_pr=
ogress);
> >                 credits.value =3D le16_to_cpu(rsp->hdr.CreditRequest);
> >                 credits.instance =3D server->reconnect_instance;
> >                 result =3D smb2_check_receive(mid, server, 0);
> >                 if (result !=3D 0) {
> > -                       trace_netfs_sreq(&wdata->subreq, netfs_sreq_tra=
ce_io_bad);
> > +                       if (is_replayable_error(result)) {
> > +                               trace_netfs_sreq(&wdata->subreq, netfs_=
sreq_trace_io_req_submitted);
> > +                               __set_bit(NETFS_SREQ_NEED_RETRY, &wdata=
->subreq.flags);
> > +                       } else {
> > +                               wdata->subreq.error =3D result;
> > +                               trace_netfs_sreq(&wdata->subreq, netfs_=
sreq_trace_io_bad);
> > +                       }
> >                         break;
> > -               }
> > +               } else
> > +                       trace_netfs_sreq(&wdata->subreq, netfs_sreq_tra=
ce_io_progress);
> >
> >                 written =3D le32_to_cpu(rsp->DataLength);
> >                 /*
> > @@ -4930,7 +4949,7 @@ smb2_writev_callback(struct TCP_Server_Info *serv=
er, struct mid_q_entry *mid)
> >                 cifs_stats_bytes_written(tcon, written);
> >
> >                 if (written < wdata->subreq.len) {
> > -                       wdata->result =3D -ENOSPC;
> > +                       result =3D -ENOSPC;
> >                 } else if (written > 0) {
> >                         wdata->subreq.len =3D written;
> >                         __set_bit(NETFS_SREQ_MADE_PROGRESS, &wdata->sub=
req.flags);
> > @@ -4972,6 +4991,7 @@ smb2_writev_callback(struct TCP_Server_Info *serv=
er, struct mid_q_entry *mid)
> >         }
> >  #endif
> >         if (result) {
> > +               wdata->result =3D result;
> >                 cifs_stats_fail_inc(tcon, SMB2_WRITE_HE);
> >                 trace_smb3_write_err(wdata->rreq->debug_id,
> >                                      wdata->subreq.debug_index,
> > @@ -4994,6 +5014,14 @@ smb2_writev_callback(struct TCP_Server_Info *ser=
ver, struct mid_q_entry *mid)
> >                               server->credits, server->in_flight,
> >                               0, cifs_trace_rw_credits_write_response_c=
lear);
> >         wdata->credits.value =3D 0;
> > +
> > +       /* see if we need to retry */
> > +       if (is_replayable_error(wdata->result) &&
> > +           smb2_should_replay(tcon,
> > +                              &wdata->retries,
> > +                              &wdata->cur_sleep))
> > +               wdata->replay =3D true;
> > +
> >         cifs_write_subrequest_terminated(wdata, result ?: written);
> >         release_mid(server, mid);
> >         trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, 0,
> > @@ -5112,7 +5140,7 @@ smb2_async_writev(struct cifs_io_subrequest *wdat=
a)
> >         }
> >  #endif
> >
> > -       if (wdata->subreq.retry_count > 0)
> > +       if (wdata->replay)
> >                 smb2_set_replay(server, &rqst);
> >
> >         cifs_dbg(FYI, "async write at %llu %u bytes iter=3D%zx\n",
> > @@ -5159,6 +5187,16 @@ smb2_async_writev(struct cifs_io_subrequest *wda=
ta)
> >  async_writev_out:
> >         cifs_small_buf_release(req);
> >  out:
> > +       /* if the send error is retryable, let netfs know about it */
> > +       if (is_replayable_error(rc) &&
> > +           smb2_should_replay(tcon,
> > +                              &wdata->retries,
> > +                              &wdata->cur_sleep)) {
> > +               wdata->replay =3D true;
> > +               trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_re=
try_needed);
> > +               __set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
> > +       }
> > +
> >         if (rc) {
> >                 trace_smb3_rw_credits(wdata->rreq->debug_id,
> >                                       wdata->subreq.debug_index,
> > --
> > 2.43.0
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Regards,
Shyam
