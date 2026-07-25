Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1075329C40
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 20:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785012288; cv=pass; b=rP9uwfUGUnZ9JAGVefQh4By8MTgQOpURJUgB+LPpp9g37wlybL6OpidL3B6m0YzutqJ3M8PwS0Q0kFP05v6C2Whje294vVL1Ku/qo+RqZsCsSEGCIlinldYWOJfgxFQdUUPqv5Nn12N1kP7vag5yOUFnSwLWU4eEf3Z/TgGo4Wc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785012288; c=relaxed/simple;
	bh=E8HiBdeH1TULEvTN9o99m6WGx9IBKM8vOt8mMzonGyc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MVVeMCWF5qAk3iNdRYBg7zWutv05zLUIXXKxcj5d0nEePR2UiKtEoIHgKRt17MNtdrzUPf06lTYGUZXrBScCa3YpCxgdzdsRz4DkMN8D++/gAAAX4TnhCyQnjDfJRiSsoUW3jQCVtv1sDho1w4Wsv4bBVswQLT7NmxNc+Z5BEto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=nZVWBG0n; arc=pass smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="nZVWBG0n"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cc891373e0so15859335ad.2
        for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 13:44:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785012285; cv=none;
        d=google.com; s=arc-20260327;
        b=CTdyDQi5FeC9YW2ClYF9T8h2gu8dF6dvzwXvfA2CMD/d3PLiKMg6RbpQJtmm0nI2aW
         x0B5favzhAFdK3AXLRG5tMUTU6aOveoT9mx+mlgojQObC254HPBSSBD2DrWuDSXWFwYV
         Ve1Pepdq3TU32aIy1FvQesrUjhqoRshCF3DdHHFcl8+AOP+GivZiuEdWP5iiM4YphipE
         3yewAR3eIvOrE0XKl9ESlNUNMkMg6AwJbPsi2wIlHWndSfsnOcfk5lB71UDlj6KpjaBt
         rbtNUZxkGAscPl9DLoL8pim86HRudCspnnnqHt1RYGZ7yaJk9ULWRWyAIn2U9dr4hJgp
         gm1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9QXi8THUDIOtvH3CogRZaDuKMdrdjmcdfQ8HIBdrED4=;
        fh=NLIex/qpZrDi3minAIxC/T/jVWGaJYCnqFquOt0F+XA=;
        b=UGK0nwbUL8KpYFznvWQ054ZNtfKqyL3oSRDGQWi69ZwHX3NpBimJfkZG5ZPFSV3zkz
         lkMxn5kP1RnV0n7XRyu08sE0jHUlsvU4lZvzhN03WnKhmsq1B80koEyTyy8pMUrqrNK4
         H9IWVuCaUH4/h3AVl8GUABhiHPf8UzTF3BwhZH5z6D1DrhFZKuHmX9AqBiUp5QFS1YyH
         4jlpzp0c/ElB5/P3SFqbBau82eP5SU08wV4p3x1EMixFmf9b9tCSleji1XSNu2uIjEOD
         WwVPEm6yrVs7oDr2m//1OiK0xQR2YfwTxZqfMSgiFy/4sKJIoIdXUo6Ak431eOlCERFu
         ZvdQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1785012285; x=1785617085; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9QXi8THUDIOtvH3CogRZaDuKMdrdjmcdfQ8HIBdrED4=;
        b=nZVWBG0ngkuqVmEjw8N34ENJkXHIrJwkzjXiOI22iotNpXpQPW+6ZeoZcDKJslNR7D
         Yd3xn62mgT92WMwaPSOydIseqzg6mcUJTOAJfcAl4HmVTIffrdSw0DTSPCYMUMmIn8NL
         E5ik1n7j16XWl6L3vSoLvTenB3AzdKXVZJwHF098GNPqsbYvZzKJV8N0jbRwdpgNHVr4
         zLfdNpWmjYlXHM7iQs4h57MvyzE2xG1AOojicCM9Me8TO4AUBWi98eIUec4/SV1h5UED
         YWeXzDN7xjO72qvRKbZWj3vnUEPmMZmzTqSMGpksu03fEXIoiq2uV45+XCiAxn0ykm86
         k/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785012285; x=1785617085;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9QXi8THUDIOtvH3CogRZaDuKMdrdjmcdfQ8HIBdrED4=;
        b=sVnQ96Rx113OKIQL8WtwAAHTlcliIotaXiGiNyEDvokX5Xt534Z+bPqgoLFCXURfUn
         vM/uGN3RDxyMN8k6mP3jIyI4lJHTO9Kt8yLop+Ou5IWECV73HADlQHD2cr7B4Dlyj4De
         OXAymPV7Z6TytInPR1wnH7/5PM5cHiFkiuB2kmUnbo51EoAX2x+pNX81UL7fFRJ2govd
         B+HpMbjqj8g+Q4aB/DmuQgrrph2L61OHOM2NL7t2Ds6wC35ILXJi8dtfAB4l04L/2/m7
         dk3YLb5ySuqAeExYPBq4KemwCRCj4zA1Nj/W/4H5VjDQUvECq15jjVQgE6ciUk3Uqcuh
         TtJw==
X-Forwarded-Encrypted: i=1; AHgh+RrrvItKXgHGdKiU4B0ygw6sPjYIqdHF3PrkhA8kCweshTnAqvsogUiIMdnM80LaVpMxD0v0C56bx5IF@vger.kernel.org
X-Gm-Message-State: AOJu0Yzpi2b24r8PiRA5Kk+JX5+1sskk9DBRsgfUbdBwR8BmyilijavQ
	lf4HQhzdaug2bUenQiidqiusJb4IZ6N9CKDXfQeDmfU6pMRXFCKy/LgqWgq7Jiw99zxIZkGDNBl
	jqpN6E7tdF7tB04a6Rud32fnQSP7PL86aIkpEGVG7
X-Gm-Gg: AR+sD10cf8IsbASEG/+NjJ6tSmMJEJQ5K1jTFIkLJs3cCNJaaCX5xge0e1Nm/KPqcqx
	AEe8NXjahVzT3OIFoLa2le0d61cOA3MLd5Ia5sB9JyAgC+B5iVXE20Z5RCkJxLz/7a2TQFltXF4
	BtVsxeysmTmNQXitH2xEgER4234TY8vGz+ZEA2A8m8qbBgj9VzrD8UoLe0v73sg2TGhN8WuxVht
	fSrlmSG2lsLPx8eIkDa+K0NefZzrxZSWgC3fQTpcwdzc/8EaIoKW7MkjpJgrVTWV/KTdFtfsdOh
	/cr/Ezf3liGyqtEepw==
X-Received: by 2002:a17:903:11c3:b0:2cc:f7c6:8353 with SMTP id
 d9443c01a7336-2cfde888581mr32492505ad.41.1785012285296; Sat, 25 Jul 2026
 13:44:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722235908.3564560-1-xmei5@asu.edu> <CAKYAXd_iJjEWhFQ7tJSDVaK66Lo8TOazAG+798ty5JUPj+bBDg@mail.gmail.com>
In-Reply-To: <CAKYAXd_iJjEWhFQ7tJSDVaK66Lo8TOazAG+798ty5JUPj+bBDg@mail.gmail.com>
From: Xiang Mei <xmei5@asu.edu>
Date: Sat, 25 Jul 2026 13:44:34 -0700
X-Gm-Features: AUfX_mwGYb4jeMMLUhwM_ISkSIl-ks6ZlsPZ7d3jkW5VSLiaPAZjuibj66pS_Iw
Message-ID: <CAPpSM+TLJPvb=3NUQZ0fStTVy983KNcGDt-oTTbGXoTJ60A=Uw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: use copied ACE count when walking DACL in set_ntacl_dacl
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hyunchul Lee <hyc.lee@gmail.com>, Ronnie Sahlberg <lsahlber@redhat.com>, 
	AutonomousCodeSecurity@microsoft.com, tgopinath@linux.microsoft.com, 
	kys@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 5:19=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Thu, Jul 23, 2026 at 8:59=E2=80=AFAM Xiang Mei (Microsoft) <xmei5@asu.=
edu> wrote:
> >
> > set_ntacl_dacl() copies ACEs from the stored, attacker-controlled DACL
> > into pndace but may copy fewer than nt_num_aces (it skips ACEs with a b=
ad
> > sid.num_subauth and breaks on size overflow). It still passes the raw
> > nt_num_aces to set_posix_acl_entries_dacl(), whose dedup loop then walk=
s
> > that many ACEs and, past the last one actually copied, reads
> > sub_auth[num_subauth - 1] from uninitialized buffer memory - an
> > out-of-bounds read whose offset comes from that stale byte.
> >
> > Pass num_aces, the count actually copied, instead. For well-formed DACL=
s
> > num_aces equals nt_num_aces, so behavior is unchanged.
> >
> >   UBSAN: array-index-out-of-bounds in fs/smb/server/smbacl.c:651:27
> >   index -1 is out of range for type '__le32 [15]'
> >   Workqueue: ksmbd-io handle_ksmbd_work
> >   Call Trace:
> >    __ubsan_handle_out_of_bounds (lib/ubsan.c:455)
> >    set_posix_acl_entries_dacl (fs/smb/server/smbacl.c:651)
> >    build_sec_desc (fs/smb/server/smbacl.c:776 fs/smb/server/smbacl.c:10=
78)
> >    smb2_query_info (fs/smb/server/smb2pdu.c:6269 fs/smb/server/smb2pdu.=
c:6339)
> >    handle_ksmbd_work (fs/smb/server/server.c:308)
> >    process_one_work (kernel/workqueue.c:3322)
> >    worker_thread (kernel/workqueue.c:3486)
> >    kthread (kernel/kthread.c:436)
> >
> > Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> > Reported-by: AutonomousCodeSecurity@microsoft.com
> > Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
> Thanks for the patch.
> Could you please check whether this issue is still present in the
> current ksmbd-for-next-next tree?

Thanks for pointing me to ksmbd-for-next-next. I am sorry I didn't
find the correct branch to test on. I'll improve my workflow to avoid
this kind of duplication.

The bug is actually fixed by 065148205b48.
The patch is complete for this issue.

-Xiang
