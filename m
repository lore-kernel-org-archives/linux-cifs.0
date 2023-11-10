Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79357EB
	for <linux-cifs@vger.kernel.org>; Fri, 10 Nov 2023 02:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gMk3Y1Al"
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08612D62
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 18:51:34 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-507bd64814fso2173900e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 09 Nov 2023 18:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699584693; x=1700189493; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dAXDZ69nrkS7N72/j7SW0+gUbbI3vxGmGI9lNSuWXMo=;
        b=gMk3Y1Alqy268ZfY5hcj0VoDgoob1VobT5llFjXWWCEYMMzYzcBaXz51Q4wiDKwj0B
         m6ZlMKGp3dwENTTA16MhmL28FLNRbnwsBg6/tFQ+lWgba/Q6Fsnqv4g4k4m17S4ZXGVf
         uCeI3Kuw2o8CHr5dv57CarIUHw3Uz5kD7ElTcYmuj3XxMEfseESQJstXZBIPIyUh7/YK
         0ArCu+I89C38nZ7vJROUiWIhxC8zTosAS1LbTHiBOQXMJLYmWVFteeaBkJAHYkpzRfZU
         RQAyPMxuosEg1rQ4AyxKxFRkmxNryvfzMY9lRsigVii8XSApAA/jnYJ036tBU1xj+SJe
         AnXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699584693; x=1700189493;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dAXDZ69nrkS7N72/j7SW0+gUbbI3vxGmGI9lNSuWXMo=;
        b=XUo1W5XT4hgW0rzl5eCz7XmyHP4QHnlQDNi/HjDKMoaNuQ07x7TgpKNYtEXIL7cBcb
         wb1KIAl7fDxuZcFl/cWGSDKcdXp3/Rj1Q7wPFPAjDHH9WB3cmJrn4Xar/JIGoqyEW5gh
         iQfML2NaSYXJDPEm/CAVYVW7yrH7MgA5qEXu+t3e+tKrz6YP/R4g9GZuLl66/xbDP9HQ
         G39f4eD7N/eFyJ2nzPUGJJ7lM7HyA2+y8a0AXtAJtzZtorgSF3RUDjN7sCw4Fl8Zv7/6
         yW8jiSzxc/mCFzEF0K7GA1B4dMaHkOMg11rP3xcWpYdPAAaYjVVwWencF16IsE7jJGLA
         7M7g==
X-Gm-Message-State: AOJu0YyGJ1aDPOKzw2x/+yLqYfyBcR8ecAG17VMZOCclNL4MM1d5GUIS
	m1YddCWCOzWsEKCu5kgZTkERdJWugdEdSFOSEI4v7axYlKK6h9RxnQc=
X-Google-Smtp-Source: AGHT+IFeUjP5/BnL8U6v/U2DBrmLCwDO04iWQmT5XaHgVC+/39xOTrJmqVMBgpSqsVlMFLaHLAfzgjhDnzOolmxA75A=
X-Received: by 2002:a05:6512:b8e:b0:507:aaa9:b07f with SMTP id
 b14-20020a0565120b8e00b00507aaa9b07fmr3510240lfv.3.1699584692448; Thu, 09 Nov
 2023 18:51:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mt-t0QDZk4Zz+cSs8=s=VhUW09erUBAtm8f7xXG3rHJqw@mail.gmail.com>
In-Reply-To: <CAH2r5mt-t0QDZk4Zz+cSs8=s=VhUW09erUBAtm8f7xXG3rHJqw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 9 Nov 2023 20:51:19 -0600
Message-ID: <CAH2r5mtWC4hX8v-CwDQC6qp4tWzdNaMSag9myYM4dGmC4zr9FA@mail.gmail.com>
Subject: Re: [PATCH][smb3 client] allow debugging session and tcon info to
 improve stats analysis and debugging
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000dc11960609c365c8"

--000000000000dc11960609c365c8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Updated patch to remove dumping of flags (tcon->Flags was already
supposed to be dumped via
the other ioctl (CIFS_IOC_GET_MNT_INFO) but it had a minor bug - will
send followon patch for that)


On Thu, Nov 9, 2023 at 3:51=E2=80=AFPM Steve French <smfrench@gmail.com> wr=
ote:
>
> [PATCH] smb3: allow debugging session and tcon info to improve stats
>  analysis and debugging
>
> When multiple mounts are to the same share from the same client it was no=
t
> possible to determine which section of /proc/fs/cifs/Stats (and DebugData=
)
> correspond to that mount.  In some recent examples this turned out to  be
> a significant problem when trying to analyze performance problems - since
> there are many cases where unless we know the tree id and session id we
> can't figure out which stats (e.g. number of SMB3.1.1 requests by type,
> the total time they take, which is slowest, how many fail etc.) apply to
> which mount.
>
> Add an ioctl to return tid, session id, tree connect count and tcon flags=
.
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--000000000000dc11960609c365c8
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-allow-dumping-session-and-tcon-id-to-improve-st.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-allow-dumping-session-and-tcon-id-to-improve-st.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_los0u0vt0>
X-Attachment-Id: f_los0u0vt0

RnJvbSAwMDNmZmEzMjZkZjQ4MTQ4NmRlNjFkNzYxODU1MTI2ZDk2ODE4NGFjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgOSBOb3YgMjAyMyAxNToyODoxMiAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGFsbG93IGR1bXBpbmcgc2Vzc2lvbiBhbmQgdGNvbiBpZCB0byBpbXByb3ZlIHN0YXRzCiBh
bmFseXNpcyBhbmQgZGVidWdnaW5nCgpXaGVuIG11bHRpcGxlIG1vdW50cyBhcmUgdG8gdGhlIHNh
bWUgc2hhcmUgZnJvbSB0aGUgc2FtZSBjbGllbnQgaXQgd2FzIG5vdApwb3NzaWJsZSB0byBkZXRl
cm1pbmUgd2hpY2ggc2VjdGlvbiBvZiAvcHJvYy9mcy9jaWZzL1N0YXRzIChhbmQgRGVidWdEYXRh
KQpjb3JyZXNwb25kIHRvIHRoYXQgbW91bnQuICBJbiBzb21lIHJlY2VudCBleGFtcGxlcyB0aGlz
IHR1cm5lZCBvdXQgdG8gIGJlCmEgc2lnbmlmaWNhbnQgcHJvYmxlbSB3aGVuIHRyeWluZyB0byBh
bmFseXplIHBlcmZvcm1hbmNlIGRhdGEgLSBzaW5jZQp0aGVyZSBhcmUgbWFueSBjYXNlcyB3aGVy
ZSB1bmxlc3Mgd2Uga25vdyB0aGUgdHJlZSBpZCBhbmQgc2Vzc2lvbiBpZCB3ZQpjYW4ndCBmaWd1
cmUgb3V0IHdoaWNoIHN0YXRzIChlLmcuIG51bWJlciBvZiBTTUIzLjEuMSByZXF1ZXN0cyBieSB0
eXBlLAp0aGUgdG90YWwgdGltZSB0aGV5IHRha2UsIHdoaWNoIGlzIHNsb3dlc3QsIGhvdyBtYW55
IGZhaWwgZXRjLikgYXBwbHkgdG8Kd2hpY2ggbW91bnQuIFRoZSBvbmx5IGV4aXN0aW5nIGxvb3Nl
bHkgcmVsYXRlZCBpb2N0bCBDSUZTX0lPQ19HRVRfTU5UX0lORk8KZG9lcyBub3QgcmV0dXJuIHRo
ZSBpbmZvcm1hdGlvbiBuZWVkZWQgdG8gdW5pcXVlbHkgaWRlbnRpZnkgd2hpY2ggdGNvbgppcyB3
aGljaCBtb3VudCBhbHRob3VnaCBpdCBkb2VzIHJldHVybiB2YXJpb3VzIGZsYWdzIGFuZCBkZXZp
Y2UgaW5mby4KCkFkZCBhIGNpZnMua28gaW9jdGwgQ0lGU19JT0NfR0VUX1RDT05fSU5GTyAoMHg4
MDEwY2YwYykgdG8gcmV0dXJuIHRpZCwKc2Vzc2lvbiBpZCwgdHJlZSBjb25uZWN0IGNvdW50LgoK
U2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgoKZm9v
Ci0tLQogZnMvc21iL2NsaWVudC9jaWZzX2lvY3RsLmggfCAgNyArKysrKysrCiBmcy9zbWIvY2xp
ZW50L2lvY3RsLmMgICAgICB8IDI1ICsrKysrKysrKysrKysrKysrKysrKysrKysKIDIgZmlsZXMg
Y2hhbmdlZCwgMzIgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2lm
c19pb2N0bC5oIGIvZnMvc21iL2NsaWVudC9jaWZzX2lvY3RsLmgKaW5kZXggMzMyNTg4ZTc3YzMx
Li43MWJkY2U3ZWE2MGMgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvY2lmc19pb2N0bC5oCisr
KyBiL2ZzL3NtYi9jbGllbnQvY2lmc19pb2N0bC5oCkBAIC0yNiw2ICsyNiwxMiBAQCBzdHJ1Y3Qg
c21iX21udF9mc19pbmZvIHsKIAlfX3U2NCAgIGNpZnNfcG9zaXhfY2FwczsKIH0gX19wYWNrZWQ7
CiAKK3N0cnVjdCBzbWJfbW50X3Rjb25faW5mbyB7CisJX191MzIJdGlkOworCV9fdTY0CXNlc3Np
b25faWQ7CisJaW50CXRjX2NvdW50OworfSBfX3BhY2tlZDsKKwogc3RydWN0IHNtYl9zbmFwc2hv
dF9hcnJheSB7CiAJX191MzIJbnVtYmVyX29mX3NuYXBzaG90czsKIAlfX3UzMgludW1iZXJfb2Zf
c25hcHNob3RzX3JldHVybmVkOwpAQCAtMTA4LDYgKzExNCw3IEBAIHN0cnVjdCBzbWIzX25vdGlm
eV9pbmZvIHsKICNkZWZpbmUgQ0lGU19JT0NfTk9USUZZIF9JT1coQ0lGU19JT0NUTF9NQUdJQywg
OSwgc3RydWN0IHNtYjNfbm90aWZ5KQogI2RlZmluZSBDSUZTX0RVTVBfRlVMTF9LRVkgX0lPV1Io
Q0lGU19JT0NUTF9NQUdJQywgMTAsIHN0cnVjdCBzbWIzX2Z1bGxfa2V5X2RlYnVnX2luZm8pCiAj
ZGVmaW5lIENJRlNfSU9DX05PVElGWV9JTkZPIF9JT1dSKENJRlNfSU9DVExfTUFHSUMsIDExLCBz
dHJ1Y3Qgc21iM19ub3RpZnlfaW5mbykKKyNkZWZpbmUgQ0lGU19JT0NfR0VUX1RDT05fSU5GTyBf
SU9SKENJRlNfSU9DVExfTUFHSUMsIDEyLCBzdHJ1Y3Qgc21iX21udF90Y29uX2luZm8pCiAjZGVm
aW5lIENJRlNfSU9DX1NIVVRET1dOIF9JT1IoJ1gnLCAxMjUsIF9fdTMyKQogCiAvKgpkaWZmIC0t
Z2l0IGEvZnMvc21iL2NsaWVudC9pb2N0bC5jIGIvZnMvc21iL2NsaWVudC9pb2N0bC5jCmluZGV4
IGY3MTYwMDAzZTBlZC4uZjEzNzMwNzUwZTg0IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2lv
Y3RsLmMKKysrIGIvZnMvc21iL2NsaWVudC9pb2N0bC5jCkBAIC0xMTcsNiArMTE3LDIxIEBAIHN0
YXRpYyBsb25nIGNpZnNfaW9jdGxfY29weWNodW5rKHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBm
aWxlICpkc3RfZmlsZSwKIAlyZXR1cm4gcmM7CiB9CiAKK3N0YXRpYyBsb25nIHNtYl9tbnRfZ2V0
X3Rjb25faW5mbyhzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCB2b2lkIF9fdXNlciAqYXJnKQorewor
CWludCByYyA9IDA7CisJc3RydWN0IHNtYl9tbnRfdGNvbl9pbmZvIHRjb25faW5mOworCisJdGNv
bl9pbmYudGlkID0gdGNvbi0+dGlkOworCXRjb25faW5mLnNlc3Npb25faWQgPSB0Y29uLT5zZXMt
PlN1aWQ7CisJdGNvbl9pbmYudGNfY291bnQgPSB0Y29uLT50Y19jb3VudDsKKworCWlmIChjb3B5
X3RvX3VzZXIoYXJnLCAmdGNvbl9pbmYsIHNpemVvZihzdHJ1Y3Qgc21iX21udF90Y29uX2luZm8p
KSkKKwkJcmMgPSAtRUZBVUxUOworCisJcmV0dXJuIHJjOworfQorCiBzdGF0aWMgbG9uZyBzbWJf
bW50X2dldF9mc2luZm8odW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwK
IAkJCQl2b2lkIF9fdXNlciAqYXJnKQogewpAQCAtNDE0LDYgKzQyOSwxNiBAQCBsb25nIGNpZnNf
aW9jdGwoc3RydWN0IGZpbGUgKmZpbGVwLCB1bnNpZ25lZCBpbnQgY29tbWFuZCwgdW5zaWduZWQg
bG9uZyBhcmcpCiAJCQl0Y29uID0gdGxpbmtfdGNvbihwU01CRmlsZS0+dGxpbmspOwogCQkJcmMg
PSBzbWJfbW50X2dldF9mc2luZm8oeGlkLCB0Y29uLCAodm9pZCBfX3VzZXIgKilhcmcpOwogCQkJ
YnJlYWs7CisJCWNhc2UgQ0lGU19JT0NfR0VUX1RDT05fSU5GTzoKKwkJCWNpZnNfc2IgPSBDSUZT
X1NCKGlub2RlLT5pX3NiKTsKKwkJCXRsaW5rID0gY2lmc19zYl90bGluayhjaWZzX3NiKTsKKwkJ
CWlmIChJU19FUlIodGxpbmspKSB7CisJCQkJcmMgPSBQVFJfRVJSKHRsaW5rKTsKKwkJCQlicmVh
azsKKwkJCX0KKwkJCXRjb24gPSB0bGlua190Y29uKHRsaW5rKTsKKwkJCXJjID0gc21iX21udF9n
ZXRfdGNvbl9pbmZvKHRjb24sICh2b2lkIF9fdXNlciAqKWFyZyk7CisJCQlicmVhazsKIAkJY2Fz
ZSBDSUZTX0VOVU1FUkFURV9TTkFQU0hPVFM6CiAJCQlpZiAocFNNQkZpbGUgPT0gTlVMTCkKIAkJ
CQlicmVhazsKLS0gCjIuMzkuMgoK
--000000000000dc11960609c365c8--
