Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890CD31714A
	for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2026 13:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792071086; cv=pass; b=KA2xKkpngYJU8DIRkFqdTCvAXYKExI8Rbil/oKHT6RtIN6yy0yyhn9UHAiwhcTI88Gp8zc/evEcjeJCmqfxocrULnlOe6uZBzem9on7kitAu8ZcQRrIU+Z04jEK17u7ivqSdSmJQr6M8cfGS+YYgMxmpQtON9DJMRVEW6FXUIXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792071086; c=relaxed/simple;
	bh=XNDWZURb+4j+tgXPsWU8Ohw98StCh+VXq56nxPCbbrI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HwC0PAtybjjg2aT9FfqiHKIEY/weXY8eW0VTBA4hJD7zh72Num22y1kGRlp3GzY36lQ4VDzwhfUjMVgZP5y9auaJJyBIwGgcJY6HMiYeQIj1hfqkC1pD5zBsEYrTO5pRuacD4mB+Xs9iyqsNNX9J1vH67UvZaqNMpMZwEDXgOhE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QNVWb8hP; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QNVWb8hP"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so6985095a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2026 06:31:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792071084; cv=none;
        d=google.com; s=arc-20260327;
        b=QT7DliTqYpVx8tDO/ll2vtTOwCKcDUmWQciJB3IoO05BMn9uHKJckwX2quuPcGHo3s
         XOskGD36P2iLkIBhGEVWIFIoZ5onKiSK1C7MwBU+45AGibsakhLP1oglpMEwZsaad4Wb
         cKYmkMdXoz7mp3gSS9StSLj+2DOO5avQCewXyvdzxWfkZUPiIofmTAJgVeKpuKUOxVLg
         vjLHHnNmvpD0a55RLmhvro7U3kbFDoxMH9sdNf/vwkJVPGr43MOXPprOqy5GaeFhBUa+
         2mbrdAmTV12fEyTjTHaYc/5Y3neA19AKGOoGf/H2JWDE17QNxJ0zKKwDj3KG+uRdtH0Z
         uAiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=cB3vqisYTdFTBVlXni/+GZh43ugBls4vHdKndatmIEo=;
        fh=jOM/nacklhiA3QLoRBiOAXkuaeJrn6/sq9SeU/hAd7Y=;
        b=ZqT2aTQZwss+cKwvqbJgzNP3TMGT+Ew9JabtncX9bUJDKMqqvlKvbEFue768GfMoeO
         tsphP26Vl3t4rtiJgrzYM8Z4+l1zpXUPVJHkzhSAa62GPX/PiloS7p4n39ZFNdNBjO2h
         rouxMGQrKU73JULcIwJzxDDtg/Me4pBd8a9+31rUCIatnVfA4wnSIy9IcTtr5MOIxJPW
         IgJUVwXE3qABHi78lm8ZTvSEHz6w9yi+GngEJi3akv9UWLHPEPMlEGNmz/Le879gZuQD
         pfb1bgIefnU6pU6jz5/+uMGDtpb6xGTLvhSmXFs18sgfFaRKSHiYyGMksSLVPWoMhmsf
         WFuQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792071084; x=1792675884; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cB3vqisYTdFTBVlXni/+GZh43ugBls4vHdKndatmIEo=;
        b=QNVWb8hPngmdEMY7z3rc+EJ4Gb46/GMy2S4eqpU1KI+kA5DEgNmJrWcxnPF6/xe4eA
         tybrD+GLK5f5uaLOsAkpphy+rTbALzQ2sZDrQJ1L0yAJ9nFYvDnoDJLl8XbAwy7yfyZr
         52ODJXr4JYim2knyJMWVQGVAdV07AGpDYEE/SqyQYia4AS+RMSkBtRBHQo1tgg1axDbT
         gTdylPX9qDfS7r1RMHcRqM7oxFkyq8xnUDJetrWC/6+zEAFRzfCmr8RYjKEkHfBKI16t
         oAGRMWE+dOAtXsQW9P3S4RkCMRWCgXCpkvunwHWY+NByLXGh27fxPGwZKV/rdevyC4Kx
         Yylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792071084; x=1792675884;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cB3vqisYTdFTBVlXni/+GZh43ugBls4vHdKndatmIEo=;
        b=mthSC+4qOpJqFkieVnD5zWrNKqw0gN+D3N/P4MZIvqzYMm9gofC3i7+2iOOBjXK1hp
         M/94gZcVSxt4qtMW6MMMDVlOB1+W1RjBdN167WUv3jBj+G1FjfzPeQ5XGvKJMnBaEXLs
         PAA4sxHpJLhAABYlmYpF8CpwTwZvoPRIxpeG+lg2vm/QHLTZJJaKbnVOnT5JEQZZn8kP
         HlShSafQvTH7wv4rLAjHuvHxTmybyFscl4ev11iLlqPKTn9zgITDHMLETYu60D3w5HZ9
         8MtnZJqrGbmnUSDbxcXLau0MZkuZMHJeNmwPBYrxmdYvgIm2BXUTHvjNUxroGZQtx4xy
         XKNg==
X-Gm-Message-State: AFq9FYJ6rvdR4/40I/m4zTl9av6iSIBi0+tJPlJqSmPYF0Od2ChQ6XFU
	RiMs4miJNgKFJIp94+Pn81btDFm/EFo8W8EOqqEpRwlAZdFnQVJcg0BI67FktI9zawfrUA9bpGo
	4tUdFmmwi/KMSLUcy4eN+t0Z7I5Ei20ao/+Wo
X-Gm-Gg: AYBFou1ndDBW/4ckGCRyiy2jdxzRc+Q90uyT6hAvRQzT10LHN0+s1sOK97WpkifAc8u
	9/X9TPRq5WGFIJ+y5HwkZoQITzwhLIB897Honxip57yV03cSwnIF31GCpGMqMbESS9mM44z1aOH
	aOE5Qq6dO//a7+KlbpsAi8Zxq1sCUXEgAWc0xnbXDKjHiGx/oLtFyCuk5+G6pvAr8W7a/zi20vO
	ZVjRTDgAg8t/9TbuHMUZ5f4IALA6xe+WEeoAqr6K7viY5vc6AZwfuJCMMS+GChJzcp9Fpw/bboc
	mtxt4EYtYTS9MT6ocONEQK/19MLExfOG3URv0LxQakG+JjOTje1VyPOhe/IRKC+cUua7KuM+qf3
	amei8vKeaWsFh78TCQgmojXAXKwDpdcHDmXhU
X-Received: by 2002:a05:6402:21cb:b0:6b1:c355:c7b3 with SMTP id
 4fb4d7f45d1cf-6b1c355cdf1mr8652742a12.25.1792071083298; Thu, 15 Oct 2026
 06:31:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANTrAmy-Py3s30cCJC8Z+fG-Kk0JY+ihHrawGMMJQsOJCoqn-A@mail.gmail.com>
 <CAKYAXd8oh3xNWV+nnTmgudZeVTYzKCUQS9-CcDsOXXS6MDpLaw@mail.gmail.com>
In-Reply-To: <CAKYAXd8oh3xNWV+nnTmgudZeVTYzKCUQS9-CcDsOXXS6MDpLaw@mail.gmail.com>
From: =?UTF-8?B?7J207ISx7ZiE?= <ihopenre@gmail.com>
Date: Thu, 15 Oct 2026 20:31:09 +0700
X-Gm-Features: AclHuK9YLot5ZZy8Q-DQ9WvzBmZ3pIEQIxicHbMSH_uncGQVu94MhI7kVGOc3yQ
Message-ID: <CANTrAmxZH=+dfz-wpknNpBAbRS8Za04sQFLnGNcs4yeZ7Vp-WA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: reject FSCTL_SET_ZERO_DATA on a directory handle
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Stefan Metzmacher <metze@samba.org>, sfrench@samba.org, 
	Tom Talpey <tom@talpey.com>
Content-Type: multipart/mixed; boundary="000000000000556069065de1109b"

--000000000000556069065de1109b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sending the formatted patch as requested, also inline below.

On Thu, Oct 15, 2026 at 8:10=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Thu, Oct 15, 2026 at 8:22=E2=80=AFPM =EC=9D=B4=EC=84=B1=ED=98=84 <ihop=
enre@gmail.com> wrote:
> >
> > Hello Namjae and linux-cifs,
> >
> > I found a remaining way to reach __kernel_write_iter() on a directory f=
ile
> > object in ksmbd, through the FSCTL_SET_ZERO_DATA path. An authenticated
> > client with a writable tree can open a directory with FILE_WRITE_DATA a=
nd
> > issue FSCTL_SET_ZERO_DATA on that handle. ksmbd_vfs_zero_data() then ca=
lls
> > kernel_write() on the directory's struct file, which has no FMODE_WRITE=
, so
> > __kernel_write_iter() trips WARN_ON_ONCE(!(file->f_mode & FMODE_WRITE))=
 and
> > panics on a panic_on_warn kernel.
> Please send the patch to the list and me.
> Thanks.

--000000000000556069065de1109b
Content-Type: application/octet-stream; 
	name="0001-ksmbd-reject-FSCTL_SET_ZERO_DATA-on-a-directory-hand.patch"
Content-Disposition: attachment; 
	filename="0001-ksmbd-reject-FSCTL_SET_ZERO_DATA-on-a-directory-hand.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mv9kub4c0>
X-Attachment-Id: f_mv9kub4c0

RnJvbSBiNDgzNTY1NTk3ZjUyZTgyZDgyYjUyMzJkMzU2ZmMwYmI0OTM0ZDg2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMZWUgU2VvbmcgSHllb24gPGlob3BlbnJlQGdtYWlsLmNvbT4K
RGF0ZTogVGh1LCAxNSBPY3QgMjAyNiAxODowNzowMyArMDcwMApTdWJqZWN0OiBbUEFUQ0hdIGtz
bWJkOiByZWplY3QgRlNDVExfU0VUX1pFUk9fREFUQSBvbiBhIGRpcmVjdG9yeSBoYW5kbGUKCkFu
IGF1dGhlbnRpY2F0ZWQgY2xpZW50IHdpdGggYSB3cml0YWJsZSB0cmVlIGNvbm5lY3Rpb24gY2Fu
IG9wZW4gYQpkaXJlY3Rvcnkgd2l0aCBGSUxFX1dSSVRFX0RBVEEgYW5kIHNlbmQgRlNDVExfU0VU
X1pFUk9fREFUQSBvbiB0aGF0CmhhbmRsZS4gVGhlIGhhbmRsZXIgb25seSBjaGVja3MgZnAtPmRh
Y2Nlc3MgJiBGSUxFX1dSSVRFX0RBVEFfTEUsIGJ1dCBvbgphIGRpcmVjdG9yeSBGSUxFX1dSSVRF
X0RBVEEgaXMgdGhlIGxlZ2l0aW1hdGUgYWRkLWZpbGUgcmlnaHQsIHNvIHRoZQpjaGVjayBwYXNz
ZXMuIGtzbWJkX3Zmc196ZXJvX2RhdGEoKSB0aGVuIGNhbGxzIGtlcm5lbF93cml0ZSgpIG9uIHRo
ZQpkaXJlY3RvcnkgZmlsZSwgd2hpY2ggaGFzIG5vIEZNT0RFX1dSSVRFLCBhbmQgX19rZXJuZWxf
d3JpdGVfaXRlcigpCmhpdHMgV0FSTl9PTl9PTkNFKCEoZmlsZS0+Zl9tb2RlICYgRk1PREVfV1JJ
VEUpKSwgcGFuaWNraW5nIGEKcGFuaWNfb25fd2FybiBrZXJuZWwuCgpCZWZvcmUgY29tbWl0IDI1
ZTQxNGRiNzAzMyAoImtzbWJkOiByZXBvcnQgaG9sZXMgaW4gYWxsb2NhdGVkIHJhbmdlCnF1ZXJp
ZXMiKSB0aGUgZGVuc2UtZmlsZSBwYXRoIHVzZWQgdmZzX2ZhbGxvY2F0ZSgpLCB3aGljaCByZWpl
Y3RzCmRpcmVjdG9yaWVzIHdpdGggLUVJU0RJUi4gVGhlIGtlcm5lbF93cml0ZSgpIGxvb3AgdGhh
dCByZXBsYWNlZCBpdCBoYXMKbm8gc3VjaCBjaGVjay4gUmVqZWN0IGEgZGlyZWN0b3J5IGhhbmRs
ZSBpbiBrc21iZF92ZnNfemVyb19kYXRhKCkgYmVmb3JlCndyaXRpbmcsIGFzIGtzbWJkX3Zmc193
cml0ZSgpIGFscmVhZHkgZG9lcyBmb3IgU01CMl9XUklURS4KCiAgV0FSTklORzogZnMvcmVhZF93
cml0ZS5jOjYwOCBhdCBfX2tlcm5lbF93cml0ZV9pdGVyKzB4NzRiLzB4OGMwCiAgV29ya3F1ZXVl
OiBrc21iZC1pbyBoYW5kbGVfa3NtYmRfd29yawogIENhbGwgVHJhY2U6CiAgIGtlcm5lbF93cml0
ZSsweDFlZi8weDRkMAogICBrc21iZF92ZnNfemVyb19kYXRhKzB4NDEzLzB4NTkwCiAgIHNtYjJf
aW9jdGwrMHgyMWZhLzB4NjZhMAogICBoYW5kbGVfa3NtYmRfd29yaysweDYxYi8weDFmZjAKCkZp
eGVzOiAyNWU0MTRkYjcwMzMgKCJrc21iZDogcmVwb3J0IGhvbGVzIGluIGFsbG9jYXRlZCByYW5n
ZSBxdWVyaWVzIikKU2lnbmVkLW9mZi1ieTogTGVlIFNlb25nIEh5ZW9uIDxpaG9wZW5yZUBnbWFp
bC5jb20+Ci0tLQpUZXN0ZWQgb24gNy4zLXJjNyAoMGZjYjA1YjcyMzQ0KSB3aXRoIEtBU0FOIGFu
ZCBwYW5pY19vbl93YXJuLiBUaGUKdHdvLXJlcXVlc3QgcmVwcm9kdWNlciAoQ1JFQVRFIGEgZGly
ZWN0b3J5IHdpdGggRklMRV9XUklURV9EQVRBLCB0aGVuCkZTQ1RMX1NFVF9aRVJPX0RBVEEgb24g
aXQpIHBhbmljcyBiZWZvcmUgdGhpcyBjaGFuZ2U7IGFmdGVyIGl0IHRoZSBGU0NUTApyZXR1cm5z
IFNUQVRVU19JTlZBTElEX1BBUkFNRVRFUiBhbmQgdGhlIHNlcnZlciBzdGF5cyB1cC4gQXBwbGll
cyB0bwprc21iZC1mb3ItbmV4dC4KCiBmcy9zbWIvc2VydmVyL3Zmcy5jIHwgOSArKysrKysrKysK
IDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9zbWIvc2Vy
dmVyL3Zmcy5jIGIvZnMvc21iL3NlcnZlci92ZnMuYwppbmRleCBjMmM5YWFhNWRlMWIuLmJiMWNh
YjQ3MWQ0YyAxMDA2NDQKLS0tIGEvZnMvc21iL3NlcnZlci92ZnMuYworKysgYi9mcy9zbWIvc2Vy
dmVyL3Zmcy5jCkBAIC05NTUsNiArOTU1LDE1IEBAIGludCBrc21iZF92ZnNfemVyb19kYXRhKHN0
cnVjdCBrc21iZF93b3JrICp3b3JrLCBzdHJ1Y3Qga3NtYmRfZmlsZSAqZnAsCiAJY2hhciAqemVy
b19idWYgPSBOVUxMOwogCWludCBlcnI7CiAKKwkvKgorCSAqIEEgZGlyZWN0b3J5IGhhbmRsZSBj
YW4gaG9sZCBGSUxFX1dSSVRFX0RBVEEgKHRoZSBhZGQtZmlsZSByaWdodCksCisJICogc28gdGhl
IGNhbGxlciBhY2Nlc3MgY2hlY2sgZG9lcyBub3QgZXhjbHVkZSBpdC4gV3JpdGluZyB6ZXJvZXMg
dG8gYQorCSAqIGRpcmVjdG9yeSBtYWtlcyBubyBzZW5zZSBhbmQga2VybmVsX3dyaXRlKCkgd291
bGQgd2FybiBvbiB0aGUKKwkgKiBkaXJlY3RvcnkgZmlsZSAobm8gRk1PREVfV1JJVEUpLCBzbyBy
ZWplY3QgaXQgaGVyZS4KKwkgKi8KKwlpZiAoU19JU0RJUihmaWxlX2lub2RlKGZwLT5maWxwKS0+
aV9tb2RlKSkKKwkJcmV0dXJuIC1FSU5WQUw7CisKIAlzbWJfYnJlYWtfYWxsX2xldklJX29wbG9j
ayh3b3JrLCBmcCwgMSk7CiAJaWYgKCF3b3JrLT50Y29uLT5wb3NpeF9leHRlbnNpb25zKSB7CiAJ
CWxvZmZfdCBzaXplID0gaV9zaXplX3JlYWQoZmlsZV9pbm9kZShmcC0+ZmlscCkpOwotLSAKMi41
My4wCgo=
--000000000000556069065de1109b--
