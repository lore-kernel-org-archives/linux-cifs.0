Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02CA2E5D2A
	for <linux-cifs@vger.kernel.org>; Fri, 15 Aug 2025 16:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755276742; cv=none; b=dDanzEp4aWdr60IX1JUIn53Vg4NXaNeozmeRQOxhHIi4d7TiXNtao5cjbXFiZ+JrqIbcXKxR99FmvEbuM5PMOG/pZSrrYD4MzSQozQHinpTtGOTYIr0ojDfwACzQhtuzJQK6w4DDWYByel2OXxLZgXIpMZBeoLAEZlOOAkzp2vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755276742; c=relaxed/simple;
	bh=aAP5AiVJUyESNpHQTJo020EYtj8Ym9tDI7OC3sRPWtw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kwnfhGH44oTjJhsSaqovwaKyS+apPXRYod5Ot5BUmB+i6r7wG2acU9q0l0zWCOVNbyqhqIXu6YEzJsHdWxzqde+Je8ls/QtRPE4nGr+o8P3Vb78qjG8mhoXd0Y2JldBB3YEpyiIKbaBeST44M4s7q44wUkmblhzgyY8VSm8euQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hm4ZG+u0; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hm4ZG+u0"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-70ba7aa136fso5573476d6.1
        for <linux-cifs@vger.kernel.org>; Fri, 15 Aug 2025 09:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755276739; x=1755881539; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MQ4WuETe6+3eIFEdLKPPc4yZq7nJrF46UDBNltoe8As=;
        b=Hm4ZG+u0P1xgC+ms1JkQJmxsrYCQ6r7tjiQgUbBY2qanjzJtWXsAE7CSbVdTflwD1b
         f5gQf+iiT2lWlPzrxyPJCR28W30aJYX2Bfpjh9lBWSacwgz92vIRKwsQda7Qv93txBeX
         /hDKY0Y3k56hpjaKHSH20QZsnUC5E0Mh/csE07fNC17I07JSncO9AtfBQeE+IN2kD8lZ
         KmE2lxRbIqApIQB7/YDoflslh1npn9nJQNlyfNwnJnOGUOz9VYR/jY32cu71e4SWLXP+
         K+InR51iNbwRPMY1Rt2lRTQ97Cm/AwdC3Hg4YOwuG8hwiC/63WPamOyDWYkVdKUdY5mP
         6mbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755276739; x=1755881539;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MQ4WuETe6+3eIFEdLKPPc4yZq7nJrF46UDBNltoe8As=;
        b=ueLdT7EmIF8s4AzJO1HrP+NXYqfF6zwf7eA8xd016gRWJOzrZwOyEQmuyMjS+vROYI
         5gk2xFtrOQ2/09SShz72hd82Bv/tRjRB7s3Ka/f+g0osCgwiXo2cpKC7EaUW+Cm8/zAv
         Nt2RH+ih1KjMMF8Eva1sxMjKUT6cTwscUbaII+I9JkAc1xsmWt9sw9gugtZexGxVP8ou
         tPAz60cuEnbihiibgW9U3GeLQJBQiJgaDViPRicvC8niElK0HVTM3fe3gToFkHIFiBY2
         H/4FineN9BJxceulcFTQrX+QCHq+YAmkNZP0PigomiKyKy41TGTxBNQGhIcYtKKcxdkR
         ckww==
X-Forwarded-Encrypted: i=1; AJvYcCVCBOvV8nLFVjYQ5eTXtbMeYxZBh8IhuYxgdyT2PJtwzeontOd4MG0vBnIDZKo/18EfTLMkd2tCP45s@vger.kernel.org
X-Gm-Message-State: AOJu0YxdUZdWdA/zAdqcWtuzKX9od5M57kyvWLpFxnof18w5fHxLiRY2
	HtXs4lX/d+C1+h6l9Qj/nKs7wyN2rJ++6usbf0ld2SL7ylU6NP75PpUHr8b2UimmbdGV0GE/Dok
	Azr6qua8EyTo29313+FwnIEPfayb84tlGV7h/
X-Gm-Gg: ASbGnctVofiCFc6LRvbx/07YRvnTDjCRXjqeG1NpviPEvFweVD9BB9PIywCZOBDnkLR
	y1W7cuSITO8crKOfe0NeMRiPXBVQEa086eC66nbGnvFsl+FPYPjTOE4MHVB+ub2dgVQFTfZ4brp
	rYD0XLzVckMLBz/wHSEvrhsNPHF3PQjfKQQsDuGUJwmys+MWGBZ6hmSSUqdJ6iIUP1+EIofOGIK
	v9ByJCu/VjqO2sY7OzHsG9z1Vt/dlaQ4ljNS8Y6Pk5qiyGzq79s
X-Google-Smtp-Source: AGHT+IHtTH0me5W53ra96h8xzQUcu3nmMORO2IIo91eL4fYpU0zi428D6qJ2HcO4deMi13RDUX2ri/yCxQnSE6pkoC4=
X-Received: by 2002:a05:6214:1c46:b0:70b:9a89:c2d with SMTP id
 6a1803df08f44-70ba7a9a7d1mr30701786d6.11.1755276739421; Fri, 15 Aug 2025
 09:52:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250812164546.29238-1-metze@samba.org> <cwxjlestdk3u5u6cqrr7cpblkfrwwx3obibhuk2wnu4ttneofm@y3fg6wpvooev>
 <706b8f8e-57f2-4d34-a6f8-c672c921e4f2@samba.org>
In-Reply-To: <706b8f8e-57f2-4d34-a6f8-c672c921e4f2@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 15 Aug 2025 11:52:07 -0500
X-Gm-Features: Ac12FXxJg2UuuFtJrw_BsGhTgyHg1njJftPhRKa7ndhbi7n9UVVCIxi5ZYR5OJM
Message-ID: <CAH2r5mvtxMnwdgz15RrSZj_Kut9WVLGK+WRGUGQD1Rs_MJEWbA@mail.gmail.com>
Subject: Re: [PATCH] smb: server: split ksmbd_rdma_stop_listening() out of ksmbd_rdma_destroy()
To: Stefan Metzmacher <metze@samba.org>
Cc: Pedro Falcato <pfalcato@suse.de>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Namjae Jeon <linkinjeon@kernel.org>, 
	Tom Talpey <tom@talpey.com>
Content-Type: multipart/mixed; boundary="0000000000008954d3063c6a36b8"

--0000000000008954d3063c6a36b8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Steve can you remove 'return' so that the line is this:
> static inline void ksmbd_rdma_stop_listening(void) {

Done, and have updated ksmbd-for-next

Updated patch also attached, let me know if any problems.

Also let me know if you have rebased versions of the other smbdirect
patches for 6.18-rc so I can get them in linux-next

On Fri, Aug 15, 2025 at 7:45=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi Pedro,
>
> >> +void ksmbd_rdma_destroy(void)
> >> +{
> >>      if (smb_direct_wq) {
> >>              destroy_workqueue(smb_direct_wq);
> >>              smb_direct_wq =3D NULL;
> >> diff --git a/fs/smb/server/transport_rdma.h b/fs/smb/server/transport_=
rdma.h
> >> index 0fb692c40e21..659ed668de2d 100644
> >> --- a/fs/smb/server/transport_rdma.h
> >> +++ b/fs/smb/server/transport_rdma.h
> >> @@ -13,13 +13,15 @@
> >>
> >>   #ifdef CONFIG_SMB_SERVER_SMBDIRECT
> >>   int ksmbd_rdma_init(void);
> >> +void ksmbd_rdma_stop_listening(void);
> >>   void ksmbd_rdma_destroy(void);
> >>   bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
> >>   void init_smbd_max_io_size(unsigned int sz);
> >>   unsigned int get_smbd_max_read_write_size(void);
> >>   #else
> >>   static inline int ksmbd_rdma_init(void) { return 0; }
> >> -static inline int ksmbd_rdma_destroy(void) { return 0; }
> >> +static inline void ksmbd_rdma_stop_listening(void) { return };
> >                                                       ^^ return; (nothi=
ng at all would be even better)
> > This seems to have broken our internal linux-next builds.
>
> Sorry for that!
>
> Steve can you remove 'return' so that the line is this:
> static inline void ksmbd_rdma_stop_listening(void) { }
>
> Thanks!
> metze



--=20
Thanks,

Steve

--0000000000008954d3063c6a36b8
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb-server-split-ksmbd_rdma_stop_listening-out-of-ks.patch"
Content-Disposition: attachment; 
	filename="0001-smb-server-split-ksmbd_rdma_stop_listening-out-of-ks.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_med2fiic0>
X-Attachment-Id: f_med2fiic0

RnJvbSBhNDk1MDEwMjNmNTBkMzllMDZjNDIwYWMwOWI3NDE4NWQwNmVlMGU2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGVmYW4gTWV0em1hY2hlciA8bWV0emVAc2FtYmEub3JnPgpE
YXRlOiBUdWUsIDEyIEF1ZyAyMDI1IDE4OjQ1OjQ2ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gc21i
OiBzZXJ2ZXI6IHNwbGl0IGtzbWJkX3JkbWFfc3RvcF9saXN0ZW5pbmcoKSBvdXQgb2YKIGtzbWJk
X3JkbWFfZGVzdHJveSgpCgpXZSBjYW4ndCBjYWxsIGRlc3Ryb3lfd29ya3F1ZXVlKHNtYl9kaXJl
Y3Rfd3EpOyBiZWZvcmUgc3RvcF9zZXNzaW9ucygpIQoKT3RoZXJ3aXNlIGFscmVhZHkgZXhpc3Rp
bmcgY29ubmVjdGlvbnMgdHJ5IHRvIHVzZSBzbWJfZGlyZWN0X3dxIGFzCmEgTlVMTCBwb2ludGVy
LgoKQ2M6IE5hbWphZSBKZW9uIDxsaW5raW5qZW9uQGtlcm5lbC5vcmc+CkNjOiBTdGV2ZSBGcmVu
Y2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KQ2M6IFRvbSBUYWxwZXkgPHRvbUB0YWxwZXkuY29tPgpD
YzogbGludXgtY2lmc0B2Z2VyLmtlcm5lbC5vcmcKQ2M6IHNhbWJhLXRlY2huaWNhbEBsaXN0cy5z
YW1iYS5vcmcKRml4ZXM6IDA2MjZlNjY0MWY2YiAoImNpZnNkOiBhZGQgc2VydmVyIGhhbmRsZXIg
Zm9yIGNlbnRyYWwgcHJvY2Vzc2luZyBhbmQgdHJhbnBvcnQgbGF5ZXJzIikKU2lnbmVkLW9mZi1i
eTogU3RlZmFuIE1ldHptYWNoZXIgPG1ldHplQHNhbWJhLm9yZz4KQWNrZWQtYnk6IE5hbWphZSBK
ZW9uIDxsaW5raW5qZW9uQGtlcm5lbC5vcmc+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8
c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvc2VydmVyL2Nvbm5lY3Rpb24uYyAg
ICAgfCAzICsrLQogZnMvc21iL3NlcnZlci90cmFuc3BvcnRfcmRtYS5jIHwgNSArKysrLQogZnMv
c21iL3NlcnZlci90cmFuc3BvcnRfcmRtYS5oIHwgNCArKystCiAzIGZpbGVzIGNoYW5nZWQsIDkg
aW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvc2VydmVy
L2Nvbm5lY3Rpb24uYyBiL2ZzL3NtYi9zZXJ2ZXIvY29ubmVjdGlvbi5jCmluZGV4IDNmMDRhMjk3
N2JhOC4uNjdjNGY3MzM5OGRmIDEwMDY0NAotLS0gYS9mcy9zbWIvc2VydmVyL2Nvbm5lY3Rpb24u
YworKysgYi9mcy9zbWIvc2VydmVyL2Nvbm5lY3Rpb24uYwpAQCAtNTA0LDcgKzUwNCw4IEBAIHZv
aWQga3NtYmRfY29ubl90cmFuc3BvcnRfZGVzdHJveSh2b2lkKQogewogCW11dGV4X2xvY2soJmlu
aXRfbG9jayk7CiAJa3NtYmRfdGNwX2Rlc3Ryb3koKTsKLQlrc21iZF9yZG1hX2Rlc3Ryb3koKTsK
Kwlrc21iZF9yZG1hX3N0b3BfbGlzdGVuaW5nKCk7CiAJc3RvcF9zZXNzaW9ucygpOworCWtzbWJk
X3JkbWFfZGVzdHJveSgpOwogCW11dGV4X3VubG9jaygmaW5pdF9sb2NrKTsKIH0KZGlmZiAtLWdp
dCBhL2ZzL3NtYi9zZXJ2ZXIvdHJhbnNwb3J0X3JkbWEuYyBiL2ZzL3NtYi9zZXJ2ZXIvdHJhbnNw
b3J0X3JkbWEuYwppbmRleCA4ZDM2NmRiNWY2MDUuLjU0NjZhYThjMzliMSAxMDA2NDQKLS0tIGEv
ZnMvc21iL3NlcnZlci90cmFuc3BvcnRfcmRtYS5jCisrKyBiL2ZzL3NtYi9zZXJ2ZXIvdHJhbnNw
b3J0X3JkbWEuYwpAQCAtMjE5NCw3ICsyMTk0LDcgQEAgaW50IGtzbWJkX3JkbWFfaW5pdCh2b2lk
KQogCXJldHVybiAwOwogfQogCi12b2lkIGtzbWJkX3JkbWFfZGVzdHJveSh2b2lkKQordm9pZCBr
c21iZF9yZG1hX3N0b3BfbGlzdGVuaW5nKHZvaWQpCiB7CiAJaWYgKCFzbWJfZGlyZWN0X2xpc3Rl
bmVyLmNtX2lkKQogCQlyZXR1cm47CkBAIC0yMjAzLDcgKzIyMDMsMTAgQEAgdm9pZCBrc21iZF9y
ZG1hX2Rlc3Ryb3kodm9pZCkKIAlyZG1hX2Rlc3Ryb3lfaWQoc21iX2RpcmVjdF9saXN0ZW5lci5j
bV9pZCk7CiAKIAlzbWJfZGlyZWN0X2xpc3RlbmVyLmNtX2lkID0gTlVMTDsKK30KIAordm9pZCBr
c21iZF9yZG1hX2Rlc3Ryb3kodm9pZCkKK3sKIAlpZiAoc21iX2RpcmVjdF93cSkgewogCQlkZXN0
cm95X3dvcmtxdWV1ZShzbWJfZGlyZWN0X3dxKTsKIAkJc21iX2RpcmVjdF93cSA9IE5VTEw7CmRp
ZmYgLS1naXQgYS9mcy9zbWIvc2VydmVyL3RyYW5zcG9ydF9yZG1hLmggYi9mcy9zbWIvc2VydmVy
L3RyYW5zcG9ydF9yZG1hLmgKaW5kZXggNzdhZWU0ZTVjOWRjLi5jMmY0NmNkNDhlNDQgMTAwNjQ0
Ci0tLSBhL2ZzL3NtYi9zZXJ2ZXIvdHJhbnNwb3J0X3JkbWEuaAorKysgYi9mcy9zbWIvc2VydmVy
L3RyYW5zcG9ydF9yZG1hLmgKQEAgLTU0LDEzICs1NCwxNSBAQCBzdHJ1Y3Qgc21iX2RpcmVjdF9k
YXRhX3RyYW5zZmVyIHsKIAogI2lmZGVmIENPTkZJR19TTUJfU0VSVkVSX1NNQkRJUkVDVAogaW50
IGtzbWJkX3JkbWFfaW5pdCh2b2lkKTsKK3ZvaWQga3NtYmRfcmRtYV9zdG9wX2xpc3RlbmluZyh2
b2lkKTsKIHZvaWQga3NtYmRfcmRtYV9kZXN0cm95KHZvaWQpOwogYm9vbCBrc21iZF9yZG1hX2Nh
cGFibGVfbmV0ZGV2KHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYpOwogdm9pZCBpbml0X3NtYmRf
bWF4X2lvX3NpemUodW5zaWduZWQgaW50IHN6KTsKIHVuc2lnbmVkIGludCBnZXRfc21iZF9tYXhf
cmVhZF93cml0ZV9zaXplKHZvaWQpOwogI2Vsc2UKIHN0YXRpYyBpbmxpbmUgaW50IGtzbWJkX3Jk
bWFfaW5pdCh2b2lkKSB7IHJldHVybiAwOyB9Ci1zdGF0aWMgaW5saW5lIGludCBrc21iZF9yZG1h
X2Rlc3Ryb3kodm9pZCkgeyByZXR1cm4gMDsgfQorc3RhdGljIGlubGluZSB2b2lkIGtzbWJkX3Jk
bWFfc3RvcF9saXN0ZW5pbmcodm9pZCkgeyB9Oworc3RhdGljIGlubGluZSB2b2lkIGtzbWJkX3Jk
bWFfZGVzdHJveSh2b2lkKSB7IHJldHVybjsgfQogc3RhdGljIGlubGluZSBib29sIGtzbWJkX3Jk
bWFfY2FwYWJsZV9uZXRkZXYoc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldikgeyByZXR1cm4gZmFs
c2U7IH0KIHN0YXRpYyBpbmxpbmUgdm9pZCBpbml0X3NtYmRfbWF4X2lvX3NpemUodW5zaWduZWQg
aW50IHN6KSB7IH0KIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IGdldF9zbWJkX21heF9yZWFk
X3dyaXRlX3NpemUodm9pZCkgeyByZXR1cm4gMDsgfQotLSAKMi40My4wCgo=
--0000000000008954d3063c6a36b8--
