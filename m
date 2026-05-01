Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19B4285CAD
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 08:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777623556; cv=pass; b=rXPFbbMAgAbCxFXSUcC7poT6IZnsbHIXczZVIbBC6bDjqgFhHeuUJwXTrLe9OtWSCpKkY7f02Fv7zHcQdLknOygzPGEhb1MUM9eekhmU3KlhR6ai0RQTGyQdbxdQT6Q3J/zdFZwIztYq8qA5sMfHh25Z8NfbSikQLVAbiMmB3VM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777623556; c=relaxed/simple;
	bh=Lu+eN3ekizYad1x1vhCFxk9heVmbaq1kuBgOprSo91o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=REtoSbftrW5EFlkwY9zvysHGTC+yPajDAuvccZheWg3uiz7Pt6X7oxUpVpls45BRHxWFisAC2OEWNdZnV74V+SaQxfFXMLB6v6XLsTfyshAHnc4/FkExkNrd/Vn4Zuc3JxySthuVT67tn8W33eQG5GZn9M6ysAIRfJrBwnGRTBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LrVOmMLx; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LrVOmMLx"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-67845996252so3216854a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 01:19:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777623553; cv=none;
        d=google.com; s=arc-20240605;
        b=JYAh6MvVYnAp7ZpzSzkp3WVWQvomIgoEuQ6Q4JhSzr+TDXYoepv3wuvce+4jXsv7Qt
         tcyeyOlPuavLbEEphJ7HTV/e6FtzqtDkpQeMcX7/XxdzkCnMWAdk0+i8v32hWOqtVlWy
         S6reSqTRLiliE8P07sjlQIOK7TnMe2Xza632Y26uWwfdPZP1IlLFE3LDHp0nNlW0hv6R
         Pt81blOVsSBz+LkLf9p9kSx7ILf4ne2qDjg0uUFoH65Ld4Ys5kPqc+DEkS0ss3bieCch
         6VL1XA9NUOBOO1hxg1sK9sS17sev6dZOUkP8+2RW9uNcxN1dNd2A3KyrbYNgGdK3sj4J
         Tdlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g9KkST0u+uud4zMsS9a0NvbTTJ64h0UQCQgI9MpDHis=;
        fh=nPg8hoTTN7UPOx/8/kKtrBcvPSl0lCQThCI/quIVrz4=;
        b=GOGyFZ33F5mRmcy+wsyeZosMAo2n3tP/0QT0CSKuxdN9H+ilV8up/EG5cjzwwNCDGc
         5kMWcXWXr0DhyhAtLvqVlrCpWwVaYgrtmLEKv+dn8No3Tu/Wan8zr3Q90wQNKiD5KX3z
         79cDGDmbyPuWLArjwz6FW1eU2geXkmB791OsN/p4XP+O6rMZyM9/OeGConuxaHDi2I4b
         rJLzE1Mau+zUg5bfBnf41rEHOm47YficBg3kapXcggUSxT8cM+dSNcgTQucGcFFXbb36
         bSMuIc9hDO+W3TZIKCn8fJ6xVEmWtBZ/Y+M8xZiY7Nn7mWQO+SOycd4s2ijksRK+hAbq
         YMww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777623553; x=1778228353; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g9KkST0u+uud4zMsS9a0NvbTTJ64h0UQCQgI9MpDHis=;
        b=LrVOmMLxgfCRVZU1N+L7FWHGaoivSuF6GxlWAMXi9Wrk/gTAemtSeR1rn6utp8+F12
         9AcMag0wxiRmBtaigLThKtr7nzfc1wS65mV8Ag88ZePS7aUq4L37AU0VL+Xeh6P51Bq9
         jPmyzhueqkRfGXeb9jfxPxctp2g1RXi+rFfv8fttHRHmnV5Hkjwh7pR56E0FN1EdN4oM
         fuCADRtA9O63rs6LeF+oZeVvU4gwPtoqD+NMStPuqYmdsn/eoB55h0Waz4qj8eWe8ol0
         yKA7oBDfgpg1CZl1dXAP8z+shjUxCVMf829PwLtXwq4rck7uTcrDjAknIUhCTou7+0H1
         VB/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777623553; x=1778228353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g9KkST0u+uud4zMsS9a0NvbTTJ64h0UQCQgI9MpDHis=;
        b=obkNbNhUpskxo8+I7L9TCVDjNBRyKH76ZFA+qqoCJIwbAyLPLE/cos+57oNpyzyfEa
         YwzLcWd7TDwIcq0Gs9NNabStAroYRfaG4Ez+yC8Rw1l/DlImpLjtXiIRl7NN1o8eks9C
         h72K2DJGfs8KW/6vEVNuUSfP0+IAKNywJdwQXgArT4O1oLBaTfCZVpvhzQS+9DEFfO6b
         5mbnu/GOWv05SaN4gqPPeNULbTxDhQQTrWlKpRMryDSk5VDaY9IwJeQgmLZ5GEy4ljFU
         V/PCn4Ea7XdOAzH2wCRTaguYh5EjYzXI4EH/LCy2Iv+tSknKAv7OB2i58Tm7rQ+94KjX
         fHLw==
X-Gm-Message-State: AOJu0Yxdk8HHWNH+Dv+2EmgWU6xsVTbGfL4hKQawsgy2A7/vxHPMU/8I
	l39oFG+fIRWe4HNScuvoXIKaRyGLP00S7ge+FHfFxmaM2RgGTbx2qpL+Tj67E3GTGnvBzMflDYn
	24dlhW22PikhK7oKE+0MEZoa8KcjqfQk=
X-Gm-Gg: AeBDieumspHXy3PBeGuV6QjllrHdoRKojsvonzZg0tvplEKM3Ab/pWB3VWM1A8HoQtl
	eWTI9xNExvtRDc1DUN8U8T24FhleXgEOWUyTr75CAaFX1LTpOwXbg+/ktUQFQf6kqiYvtZNwRYi
	6a156iKs2QbPHzMJP6l+6hcUu4EdsD0/b8vcxwciNTyDsiF50ORZMZqx6IGqgPLD9PKpvNiyF9r
	ZEixttgae+BBPXkBtArR9RaGXIUCvIWdhBkxyRAMXgQ2LmJED/Inp95rXNcOy417LnvVFQMnPCp
	9V+kvR1NdX4Ryjw5
X-Received: by 2002:a17:907:928d:b0:ba4:e5e5:58b4 with SMTP id
 a640c23a62f3a-bbac67c2706mr428736266b.20.1777623552667; Fri, 01 May 2026
 01:19:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428160804.281745-1-sprasad@microsoft.com>
 <20260428160804.281745-17-sprasad@microsoft.com> <afDr5VhyWx9MIQHU@suse.de>
In-Reply-To: <afDr5VhyWx9MIQHU@suse.de>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 1 May 2026 13:49:01 +0530
X-Gm-Features: AVHnY4ITsKf9eWNcP7LdEs_iF1_7WenjpEHV5DkfhhdszJoBEmrD3J7K9uw2Sjs
Message-ID: <CANT5p=r512+At=K1gu8iaKgYW_0Z382rG+ybYVW+kGwisj=CVw@mail.gmail.com>
Subject: Re: [PATCH v3 17/19] cifs: discard functions should not return failure
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.org, 
	bharathsm@microsoft.com, dhowells@redhat.com, henrique.carvalho@suse.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 28, 2026 at 10:58=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de=
> wrote:
>
> On 04/28, nspmangalore@gmail.com wrote:
> >From: Shyam Prasad N <sprasad@microsoft.com>
> >
> >If discard functions for readv and query_dir return error, the
> >callback functions can be skipped. This can end up with hung
> >syscalls due to the completion functions not getting called.
> >
> >This change ensures that both these discard functions return
> >success even when discard from socket returned error. This
> >ensures that at least after the mid for the response is found,
> >the callback doesn't get skipped, and we do not leave syscalls
> >waiting.
>
Hi Enzo,

Thanks for the review.

> Then we'll also be returning wrong errors to callers?
No. The errors returned are what is set in qd_io->result or rdata->result.
>
> Either way, if this is a special case for query dir, just
> call __cifs_readv_discard() from the new
> cifs_query_dir_receive() and ignore the error there
> (but you really shouldn't).
>
> __cifs_readv_discard() is used in other places (mostly indirectly)
> and returns important errors from deep down cifs_readv_from_socket()
> (e.g. -ECONNABORTED, -ESHUTDOWN, -EINTR) so modifying it for all
> callers doesn't sound good.

The return value from these functions are returned as is by the
receive handlers (both for query_dir and read). cifsd uses this to
determine that there was an error reading from socket and hence we
cannot call mid handlers (because mid cannot be identified).

However, these functions are always called after the mid is
identified. Hence it is imperative that we return 0 to cifsd to ensure
that the corresponding handler gets called. Otherwise, we leave the
mid hanging.
Alternatively, we could set qd_io->result or rdata->result to the
length read from the socket and return 0 to callers. That way, this
return value can be checked for retry by the main I/O process.
Let me give that a shot and see how it works.

>
> >Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> >---
> > fs/smb/client/transport.c | 16 ++++++++--------
> > 1 file changed, 8 insertions(+), 8 deletions(-)
> >
> >diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> >index 1e9e6f3f9a06f..85fa5751781a8 100644
> >--- a/fs/smb/client/transport.c
> >+++ b/fs/smb/client/transport.c
> >@@ -1137,13 +1137,13 @@ static int
> > __cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry=
 *mid,
> >                    bool malformed)
> > {
> >-      int length;
> >-
> >-      length =3D cifs_discard_remaining_data(server);
> >+      cifs_discard_remaining_data(server);
> >       dequeue_mid(server, mid, malformed);
> >       mid->resp_buf =3D server->smallbuf;
> >       server->smallbuf =3D NULL;
> >-      return length;
> >+
> >+      /* Once the mid is dequeued, the callback must run to terminate t=
he subreq. */
> >+      return 0;
> > }
> >
> > static int
> >@@ -1158,13 +1158,13 @@ static int
> > cifs_query_dir_discard(struct TCP_Server_Info *server, struct mid_q_ent=
ry *mid,
> >                     bool malformed)
> > {
> >-      int length;
> >-
> >-      length =3D cifs_discard_remaining_data(server);
> >+      cifs_discard_remaining_data(server);
> >       dequeue_mid(server, mid, malformed);
> >       mid->resp_buf =3D server->smallbuf;
> >       server->smallbuf =3D NULL;
> >-      return length;
> >+
> >+      /* Once the mid is dequeued, the callback must run to complete qd=
_io->done. */
> >+      return 0;
> > }
> >
> > /*
> >--
> >2.43.0
> >
> >



--=20
Regards,
Shyam
