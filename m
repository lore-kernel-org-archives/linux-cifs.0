Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203592BF00C
	for <linux-cifs@vger.kernel.org>; Wed, 25 Jun 2025 16:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750868295; cv=none; b=T1faqKHz0COwPDuQanticKFvKhzp285G0LMK64ZpeAfZ9x5hTe8lgtfKzjbB6k2FG+cNcCZ5aLr3JXJ3obsHBP19xe5UXysqbUHiXjmb3lwWAGjqR4P3lmtLMe+ENsV/gPrvUKMV5f3+zizD2yzdQXdjF2dZ8o/79Rwoekk/s3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750868295; c=relaxed/simple;
	bh=GP8QyAtyVq11TlTI8xtrp09rkmw9qeGsNkJ+6QEEVmw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UiM3mwH0GmgY6oE7b+Qww352EOUWIgtcW6vocvMIo/h+tCgyqK2l7g2rDSldojTsaL1T4qp5oEdC4rwDJkn3HC8LTG5WyvctOH6k3m5XUGq43t3mxkzP+Nwp8ZPNl1m3dUzp2PWKNxCNmdTJh25zja2RNhu0Q5f7mnDQKikN5y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZMMNi+YN; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZMMNi+YN"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6fadb9a0325so954266d6.2
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jun 2025 09:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750868292; x=1751473092; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WfT2F4WO2WkloBm9pwG8+Zygrf5do3v691T8Lv7s6Gs=;
        b=ZMMNi+YNtdqqJuocj/gmiTyG9L9ExdQPUXQJFTAscalkIUFccqgtiuiipHrqpIJhzK
         8Qg35FD2NoIcOTYcJP59GxpxEzJ+kXJuiGwqP9Cn6fQI+Hqu9zQnpuP40SAx4FiPK/PA
         PlsJHUPXexFi0YByo7Hj6+z/8d+LUa5+/F0VPoI9yJasxYB9V1fIceWvVa67TulDwRra
         RaQA3gydluvRMO5MBSHq9t9tR8382IboKtvPeOriUzMiYvs532ZTavnG52iT92R77h0q
         e5p5og3DQk7yNeELvLNdWBrFpBHhUD2/RQ9l/fqkScAnVP3vRNvRZWObUe2pHCf3yvK0
         zb9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750868292; x=1751473092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WfT2F4WO2WkloBm9pwG8+Zygrf5do3v691T8Lv7s6Gs=;
        b=L7xalfoHGMH9w14mmQ0GzVFLeS6tsY3IfNpfZHZv7+qyOUs1cJje/3+R8lJRspp6M0
         50PHqR20QyKyraePmw0LoFejSktxwfHn3yjr+F+6HESzlToxMduLYwtw2QFw/BT8SIOA
         NJNigI6drJ31nV3s0kdhJ650giz/ZWrBS5w+liaatDhcAitQUKIx3oOBeUpxwzsm2u9N
         CkNM3WsVzqyr7yDfUoUwzogV1oxYtfBPikwhpsWta7sOduZJCv/zOugtsLQT8SrbUeWr
         srC9vcbMdI9PIxj3lrPC+eLGug+TohCuN8SFol99no+O9W4o6YhhXGdJCGsxPUQBqZq9
         86Zw==
X-Forwarded-Encrypted: i=1; AJvYcCVQFQiz+pqE4etDWi0mCfDClUcm8lA4/RDpjdUfhf0WeVIIntIwLU8HTCmueOl6Nuf4iDfU2FYuhp00@vger.kernel.org
X-Gm-Message-State: AOJu0YzEfWshG7U/YySFNRFMJnSeIRYA8wgI84SAQ6Pnzy8rxgKJczCb
	WrLK8MlWmi8Pe4fzSSByX+3FMhMqcnzC6sIFaKFkjSYriYVxcXRrn2Jyev2B+6YLQVTLMqxf9kq
	TyZYK2RtDZAI9nIZqXAlhIGu+NhiQo+0=
X-Gm-Gg: ASbGncsQSFxT20gHGQkTEEX3/mm04oHpyIoSPmuLbpQnwK3TUZghJU8b84iu5Js3McX
	5mbqghp4Fqxi6Zr+tmGyTLKq/0n9Q17jHiQxp9eDRj3WPyLoLzL1w79AehLi7jRpuP7ypHAQErR
	07ky1yv+mn7mVdmjJNO+lKvWjkK33c+ZCZ+C1FDltQA8SpoA7T6NER8l4wVb2cSOIhiSztxI01w
	k/xOlkJ0QbXmsM=
X-Google-Smtp-Source: AGHT+IELVnY9tWrfOK3EsALn6P8OmKArGPKfHIvcM+6sdbam/jdoARe6b70fUsDAprc8WsO3jhu7dqTc4yo34L1olQk=
X-Received: by 2002:a05:6214:319e:b0:6fa:fddf:7343 with SMTP id
 6a1803df08f44-6fd5efac289mr66108346d6.23.1750868291450; Wed, 25 Jun 2025
 09:18:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250625081638.944583-1-metze@samba.org> <1288833.1750842098@warthog.procyon.org.uk>
In-Reply-To: <1288833.1750842098@warthog.procyon.org.uk>
From: Steve French <smfrench@gmail.com>
Date: Wed, 25 Jun 2025 11:17:59 -0500
X-Gm-Features: Ac12FXzxnQoEVJkG624DXsVcwyPbnW2_OyENvdllI_HLO4Jis4ayKMsY_20entg
Message-ID: <CAH2r5mutiF0D6_SGSguYD2zbJCtZj454DQQMGO8JmJ9VtyqSmA@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: let smbd_post_send_iter() respect the
 peers max_send_size and transmit all data
To: David Howells <dhowells@redhat.com>
Cc: Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Tom Talpey <tom@talpey.com>, 
	stable+noautosel@kernel.org, Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Added to cifs-2.6.git for-next and updated with rb and tested-by from
David and tested-by from Meetakshi

On Wed, Jun 25, 2025 at 4:03=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> Stefan Metzmacher <metze@samba.org> wrote:
>
> > We should not send smbdirect_data_transfer messages larger than
> > the negotiated max_send_size, typically 1364 bytes, which means
> > 24 bytes of the smbdirect_data_transfer header + 1340 payload bytes.
> >
> > This happened when doing an SMB2 write with more than 1340 bytes
> > (which is done inline as it's below rdma_readwrite_threshold).
> >
> > It means the peer resets the connection.
> >
> > When testing between cifs.ko and ksmbd.ko something like this
> > is logged:
> >
> > client:
> >
> >     CIFS: VFS: RDMA transport re-established
> >     siw: got TERMINATE. layer 1, type 2, code 2
> >     siw: got TERMINATE. layer 1, type 2, code 2
> >     siw: got TERMINATE. layer 1, type 2, code 2
> >     siw: got TERMINATE. layer 1, type 2, code 2
> >     siw: got TERMINATE. layer 1, type 2, code 2
> >     siw: got TERMINATE. layer 1, type 2, code 2
> >     siw: got TERMINATE. layer 1, type 2, code 2
> >     siw: got TERMINATE. layer 1, type 2, code 2
> >     siw: got TERMINATE. layer 1, type 2, code 2
> >     CIFS: VFS: \\carina Send error in SessSetup =3D -11
> >     smb2_reconnect: 12 callbacks suppressed
> >     CIFS: VFS: reconnect tcon failed rc =3D -11
> >     CIFS: VFS: reconnect tcon failed rc =3D -11
> >     CIFS: VFS: reconnect tcon failed rc =3D -11
> >     CIFS: VFS: SMB: Zero rsize calculated, using minimum value 65536
> >
> > and:
> >
> >     CIFS: VFS: RDMA transport re-established
> >     siw: got TERMINATE. layer 1, type 2, code 2
> >     CIFS: VFS: smbd_recv:1894 disconnected
> >     siw: got TERMINATE. layer 1, type 2, code 2
> >
> > The ksmbd dmesg is showing things like:
> >
> >     smb_direct: Recv error. status=3D'local length error (1)' opcode=3D=
128
> >     smb_direct: disconnected
> >     smb_direct: Recv error. status=3D'local length error (1)' opcode=3D=
128
> >     ksmbd: smb_direct: disconnected
> >     ksmbd: sock_read failed: -107
> >
> > As smbd_post_send_iter() limits the transmitted number of bytes
> > we need loop over it in order to transmit the whole iter.
> >
> > Cc: Steve French <sfrench@samba.org>
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: Tom Talpey <tom@talpey.com>
> > Cc: linux-cifs@vger.kernel.org
> > Cc: <stable+noautosel@kernel.org> # sp->max_send_size should be info->m=
ax_send_size in backports
> > Fixes: 3d78fe73fa12 ("cifs: Build the RDMA SGE list directly from an it=
erator")
> > Signed-off-by: Stefan Metzmacher <metze@samba.org>
>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Tested-by: David Howells <dhowells@redhat.com>
>
>


--=20
Thanks,

Steve
