Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67F241C63
	for <linux-cifs@vger.kernel.org>; Fri, 15 Aug 2025 18:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755283979; cv=none; b=Ysi6zLgPYz+Ge/ghFLH6m7Lng9h1NOtmOHFFc9hK992D3cJ+YGXn2wPp6FQ4VDqtjgDZy7nFkR7shjiYWkdO3/DgjMEYleTciB7h/12xPCuf9eCOeZPK564M4i8GZJeqwu+1JHUR/PFmBmfGwd1IogCyjGI8vdvY6SgCullxfqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755283979; c=relaxed/simple;
	bh=4SHgl2gMaSKIkR41weBTRaehGZfk2kBbnEdnErP3+MQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uVuugtnU5TjK+J1Sus/jMBHjqctN5A61FwjOiwUmy714VMjDKTaLUe51iZ0S9gX++8DzEdqHZS0uw8LWWeIGSknAEu6v1xVKyo4MD4+n5DNj+ABxNYAX5R34AXf/BTnFxkYMAlUObAeoSd+o5qkShe5UoCl02uNLWrwEIjipom0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IzFIQV+v; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IzFIQV+v"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-70a88dd062eso20907306d6.0
        for <linux-cifs@vger.kernel.org>; Fri, 15 Aug 2025 11:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755283977; x=1755888777; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JdyN6WGrqk0qlIimHEpOBWJyn0gKIKwkZ/kscgd9yuQ=;
        b=IzFIQV+vLOHUp5epPw65vn47nY/8+KRZytZBl1bJMJT0MnXHwj2i2NfdLc04L1pSbe
         aPAuaWAs2zTjqM86WcmoX7g/07iGrOaA1XC/wFTkDnWc5Se5K2mC+8LaNYKdcbXdkF+u
         PaJKRH/wtIMzCj2efe9upldsfzYDk1j1YXALUuXwnLo6OVdzpryeY5toSkajP2GWovFS
         Wrli/e0z62X7NUX/q5eRG8x7YRaXsEuNJu2Oaw5fv27dFMuqZTHBXmYFiRT8eOq7V/SP
         OsWhOv7tL/LLTJ/L6SsDNhdZpEpmRryRrQ2VXCd4g1q7koX8fD1hZdgkTNQubq1boEvg
         +99Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755283977; x=1755888777;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JdyN6WGrqk0qlIimHEpOBWJyn0gKIKwkZ/kscgd9yuQ=;
        b=IAKooldo7/9zBSsQeleowlMuosXFNYvdZGqcdMzU9RbYZNYT0haLeme1JJ95zZZf8Z
         rn2+T2tO7PIS4Vb6710DU1ixHlAUgkMqNtxGUp0YV0XghMtNV1WUunDTpQMJS5+qordO
         tkV4g6efMTT4yU7QgH/KP40mqioJCQikVmjxUmVSIa98BNDIg+FaZK/1wROrEe7IO8yR
         yZjWnwiIe7jr4rVlwHSciwktzg7NmUnOtFy9mC/GSLt4/a9TML4fqs2A05TS3AXagYhT
         50dlqukm/gy6NxJSX0LfCwBqaVhXvPeaL/YZnsZxDt1krh+k2B0eCsT7QAHv+c8yq78u
         xZLg==
X-Forwarded-Encrypted: i=1; AJvYcCWjRvgo84F0O0+PQ5baLj93m9WFSAcl52mfIc3hDHfam/078jxN6kiOJqJH7motTSy6SMwu9R6qBbQH@vger.kernel.org
X-Gm-Message-State: AOJu0YxO6SPjr1BODDCPKHTS1WNTV3k8bgHR2i3aiomXf6d8Eg/a6/hW
	J9zUuaBZSEjbGULZnHAzfOOGQCDx0+o9UV6EJiDSoITHS/v6tvn4UzauB+LtaAQIFWxhJlkUOct
	VcUo8/YlV3dGutM9t3MSRfGQiaxA8dqo=
X-Gm-Gg: ASbGnctxfdC5uIu+fpJmyIR2s8J41k11vev6WKD5EyAhPMGGdnNb+lf8Iv0uciIUoC2
	uvFHN6aYN4bbrZPkLZP1XI3Esnzm/aDTFx0TDpfGg+37z5LdGnNtxArhG3JmgCd/MBQuOTMxuhw
	1sQSOBQlKip0zP468Smi7Sj/k+UStQ+/bGIg+x2aG9Vk8P1sJIlpe5ya1Xq0QU0rL/1uf4kwF3S
	tzLEX2jgBqM6wFdLTSAa9BOnFATtv08wFBoB00A3A==
X-Google-Smtp-Source: AGHT+IHD+xBmJAin9zj3WSwmYl22L1CYJTaMu9iVRXfDe7O50dZ9zSrnq/9Ck/5Ix1eFfDnsvjP8jrKvgpw63x3GkoM=
X-Received: by 2002:a05:6214:f2c:b0:707:56bd:906f with SMTP id
 6a1803df08f44-70ba7ae85camr36370706d6.17.1755283976846; Fri, 15 Aug 2025
 11:52:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250812164546.29238-1-metze@samba.org> <cwxjlestdk3u5u6cqrr7cpblkfrwwx3obibhuk2wnu4ttneofm@y3fg6wpvooev>
 <706b8f8e-57f2-4d34-a6f8-c672c921e4f2@samba.org> <CAH2r5mvtxMnwdgz15RrSZj_Kut9WVLGK+WRGUGQD1Rs_MJEWbA@mail.gmail.com>
 <0bcae9fe-1dff-4530-875b-fe917af5b649@samba.org>
In-Reply-To: <0bcae9fe-1dff-4530-875b-fe917af5b649@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 15 Aug 2025 13:52:44 -0500
X-Gm-Features: Ac12FXy5OtU2K4dWp9NkoumOvpMO0vbMmWRZC4lTQxEL6_bw9NEbEHMwQjYcbwE
Message-ID: <CAH2r5mtas+irtVpkkCYRLyXpPknXqbAiN9gdupo-5z=YbFepTQ@mail.gmail.com>
Subject: Re: [PATCH] smb: server: split ksmbd_rdma_stop_listening() out of ksmbd_rdma_destroy()
To: Stefan Metzmacher <metze@samba.org>
Cc: Pedro Falcato <pfalcato@suse.de>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Namjae Jeon <linkinjeon@kernel.org>, 
	Tom Talpey <tom@talpey.com>
Content-Type: multipart/mixed; boundary="000000000000eba7ea063c6be504"

--000000000000eba7ea063c6be504
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Maybe also remove the 'return;' from the inline ksmbd_rdma_destroy functi=
on?

Done (updated cifs-2.6.git for-next with attached)

It does look a little strange that a trailing ';' is only after the
ksmbd_rdma_stop_listening() line - is that intentional

diff --git a/fs/smb/server/transport_rdma.h b/fs/smb/server/transport_rdma.=
h
index 77aee4e5c9dc..ce3c88a45875 100644
--- a/fs/smb/server/transport_rdma.h
+++ b/fs/smb/server/transport_rdma.h
@@ -54,13 +54,15 @@ struct smb_direct_data_transfer {

 #ifdef CONFIG_SMB_SERVER_SMBDIRECT
 int ksmbd_rdma_init(void);
+void ksmbd_rdma_stop_listening(void);
 void ksmbd_rdma_destroy(void);
 bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
 void init_smbd_max_io_size(unsigned int sz);
 unsigned int get_smbd_max_read_write_size(void);
 #else
 static inline int ksmbd_rdma_init(void) { return 0; }
-static inline int ksmbd_rdma_destroy(void) { return 0; }
+static inline void ksmbd_rdma_stop_listening(void) { };
+static inline void ksmbd_rdma_destroy(void) { }
 static inline bool ksmbd_rdma_capable_netdev(struct net_device
*netdev) { return false; }
 static inline void init_smbd_max_io_size(unsigned int sz) { }
 static inline unsigned int get_smbd_max_read_write_size(void) { return 0; =
}

On Fri, Aug 15, 2025 at 12:24=E2=80=AFPM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Am 15.08.25 um 18:52 schrieb Steve French:
> >> Steve can you remove 'return' so that the line is this:
> >> static inline void ksmbd_rdma_stop_listening(void) {
> >
> > Done, and have updated ksmbd-for-next
> >
> > Updated patch also attached, let me know if any problems.
>
> Maybe also remove the 'return;' from the inline ksmbd_rdma_destroy functi=
on?
>
> > Also let me know if you have rebased versions of the other smbdirect
> > patches for 6.18-rc so I can get them in linux-next
>
> I guess I'll base on Monday on 6.17-rc2 and will post what I have then.
>
> Thanks!
> metze
>


--=20
Thanks,

Steve

--000000000000eba7ea063c6be504
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb-server-split-ksmbd_rdma_stop_listening-out-of-ks.patch"
Content-Disposition: attachment; 
	filename="0001-smb-server-split-ksmbd_rdma_stop_listening-out-of-ks.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_med6qycc0>
X-Attachment-Id: f_med6qycc0

RnJvbSA2NTYyMDVkYjY1MGE5OTQyYTMzYjVjYzViYzkwMTJjMzMxNzQ2NTk2IE1vbiBTZXAgMTcg
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
L3RyYW5zcG9ydF9yZG1hLmgKaW5kZXggNzdhZWU0ZTVjOWRjLi5jZTNjODhhNDU4NzUgMTAwNjQ0
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
bWFfZGVzdHJveSh2b2lkKSB7IH0KIHN0YXRpYyBpbmxpbmUgYm9vbCBrc21iZF9yZG1hX2NhcGFi
bGVfbmV0ZGV2KHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYpIHsgcmV0dXJuIGZhbHNlOyB9CiBz
dGF0aWMgaW5saW5lIHZvaWQgaW5pdF9zbWJkX21heF9pb19zaXplKHVuc2lnbmVkIGludCBzeikg
eyB9CiBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGludCBnZXRfc21iZF9tYXhfcmVhZF93cml0ZV9z
aXplKHZvaWQpIHsgcmV0dXJuIDA7IH0KLS0gCjIuNDMuMAoK
--000000000000eba7ea063c6be504--
