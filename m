Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E747EFBE1;
	Sat, 13 Jan 2024 05:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U8yeCaM+"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2cd0f4f306fso84272571fa.0;
        Fri, 12 Jan 2024 21:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705123266; x=1705728066; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0ATnlsK6lgODy5NUJw0CqklMcLHoFP3eiosAXvJ+YZ8=;
        b=U8yeCaM+7V1LydLaGSFnU2somNb9DWCpja2Juzfr1iUkVrenv/4VEJC2qRvrFIK+SY
         zv86C8mi6uxX3oLtWByNZ/YJxW86SVAjUuy5wwZIyLwuS0K0wXEHu1d2VAU6gqQ8pnza
         CPX2znhwi8sW7K2ijzHDswiE6m0Iy7vPSWrlukq7q06JeEq+0RyL6v4n/EgIJzL2yXL4
         3Is5jt7PuzFNtrR8CT6SwoCvX0rcwu2fFMtZ5W1C530nnZH1Xw/NL0nPBwGvSpFLTDct
         0nUy7b0BESOjQnnL9a7adAxPYWqWlgsSHV/mTlM7TqwDhKjfMc1MU47fgp0Iuh38mUrm
         9dCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705123266; x=1705728066;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0ATnlsK6lgODy5NUJw0CqklMcLHoFP3eiosAXvJ+YZ8=;
        b=C3/pytuxgW70vSK0w6TGAJCdnuQUGOLw2MQ+aiG9A/2f51ISz0CZy4r1waWP6m+c5K
         1RTqE0Ekcd+OmqhvlqQIpFFr/eG7wlk4Zl9CYmaOL5uTBL+1gUBC0fWOB8trR4yiivIt
         VVr2993ETD5adUz0FPmBRFUxec8x7GDzvfIgy/IWn8ql7BfF0YNIjKYozeKnv+eLRwj3
         t+M3K+IPfE4H2kesilRx+0TLouhj25X0ufo/pReuLPQWaLedL0mZhF7yjMttQ01vxrm8
         ptt7hw0PC+2rqPi6JYaNs+8fGV7roEVOKXGe8maEvsEqsuteyPo+VvSNPB1Cgf4mFWEj
         9KyQ==
X-Gm-Message-State: AOJu0YwCmhVnmEY1uJrVYryP8FpXNv5SJH/ewogqYmnL7jUeJWQgsffj
	y5MLfvirwbk4WzZ2WIByvnTlHbN50enNRuHpBN4=
X-Google-Smtp-Source: AGHT+IGCHxLEubxnG2m3vwrmBVwifiZKUYVAjT/HRvQ/RzuLq1/miwRy49cqvtFJ5+zeaGIE6C7aZvijkBc1kV2oIYw=
X-Received: by 2002:a2e:3816:0:b0:2cc:ea7b:e6cb with SMTP id
 f22-20020a2e3816000000b002ccea7be6cbmr1080625lja.105.1705123265618; Fri, 12
 Jan 2024 21:21:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2023121124-trifle-uncharted-2622@gregkh> <a76b370f93cb928c049b94e1fde0d2da506dfcb2.camel@amazon.com>
 <ZZhrpNJ3zxMR8wcU@eldamar.lan> <8e59220d-b0f3-4dae-afc3-36acfa6873e4@leemhuis.info>
 <ZZk6qA54A-KfzmSz@eldamar.lan> <13a70cc5-78fc-49a4-8d78-41e5479e3023@leemhuis.info>
 <ZZ7Dy69ZJCEyKhhS@eldamar.lan> <2024011115-neatly-trout-5532@gregkh> <2162049.1705069551@warthog.procyon.org.uk>
In-Reply-To: <2162049.1705069551@warthog.procyon.org.uk>
From: Steve French <smfrench@gmail.com>
Date: Fri, 12 Jan 2024 23:20:53 -0600
Message-ID: <CAH2r5mtBSvp9D8s3bX7KNWjXdTuOHPx5Z005jp8F5kuJgU3Z-g@mail.gmail.com>
Subject: Re: [Regression 6.1.y] From "cifs: Fix flushing, invalidation and
 file size with copy_file_range()"
To: David Howells <dhowells@redhat.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Salvatore Bonaccorso <carnil@debian.org>, 
	Paulo Alcantara <pc@manguebit.com>, Shyam Prasad N <nspmangalore@gmail.com>, 
	Rohith Surabattula <rohiths.msft@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Steve French <stfrench@microsoft.com>, 
	"Jitindar Singh, Suraj" <surajjs@amazon.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>, stable@vger.kernel.org, 
	linux-cifs@vger.kernel.org, 
	Linux regressions mailing list <regressions@lists.linux.dev>
Content-Type: multipart/mixed; boundary="0000000000008bb767060eccf210"

--0000000000008bb767060eccf210
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Here is a patch similar to what David suggested.  Seems
straightforward fix.  See attached.
I did limited testing on it tonight with 6.1 (will do more tomorrow,
but feedback welcome) but it did fix the regression in xfstest
generic/001 mentioned in this thread.




On Fri, Jan 12, 2024 at 8:26=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> gregkh@linuxfoundation.org <gregkh@linuxfoundation.org> wrote:
>
> > I guess I can just revert the single commit here?  Can someone send me
> > the revert that I need to do so as I get it right?
>
> In cifs_flush_folio() the error check for filemap_get_folio() just needs
> changing to check !folio instead of IS_ERR(folio).
>
> David
>
>


--
Thanks,

Steve

--0000000000008bb767060eccf210
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-flushing-folio-regression-for-6.1-backport.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-flushing-folio-regression-for-6.1-backport.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lrbmcxfm0>
X-Attachment-Id: f_lrbmcxfm0

RnJvbSBiYTI4OGE4NzNmYjhhYzNkMWJmNTU2MzM2NjU1OGE5MDU2MjBjMDcxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMTIgSmFuIDIwMjQgMjM6MDg6NTEgLTA2MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggZmx1c2hpbmcgZm9saW8gcmVncmVzc2lvbiBmb3IgNi4xIGJhY2twb3J0CgpmaWxl
bWFwX2dldF9mb2xpbyB3b3JrcyBkaWZmZXJlbnR5IGluIDYuMSB2cy4gbGF0ZXIga2VybmVscwoo
cmV0dXJuaW5nIE5VTEwgaW4gNi4xIGluc3RlYWQgb2YgYW4gZXJyb3IpLiAgQWRkCnRoaXMgbWlu
b3IgY29ycmVjdGlvbiB3aGljaCBhZGRyZXNzZXMgdGhlIHJlZ3Jlc3Npb24gaW4gdGhlIHBhdGNo
OgogIGNpZnM6IEZpeCBmbHVzaGluZywgaW52YWxpZGF0aW9uIGFuZCBmaWxlIHNpemUgd2l0aCBj
b3B5X2ZpbGVfcmFuZ2UoKQoKU3VnZ2VzdGVkLWJ5OiBEYXZpZCBIb3dlbGxzIDxkaG93ZWxsc0By
ZWRoYXQuY29tPgpSZXBvcnRlZC1ieTogU2FsdmF0b3JlIEJvbmFjY29yc28gPGNhcm5pbEBkZWJp
YW4ub3JnPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5j
b20+Ci0tLQogZnMvc21iL2NsaWVudC9jaWZzZnMuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQv
Y2lmc2ZzLmMgYi9mcy9zbWIvY2xpZW50L2NpZnNmcy5jCmluZGV4IDJlMTViMTgyZTU5Zi4uYWMw
YjdmMjI5YTIzIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2NpZnNmcy5jCisrKyBiL2ZzL3Nt
Yi9jbGllbnQvY2lmc2ZzLmMKQEAgLTEyNDAsNyArMTI0MCw3IEBAIHN0YXRpYyBpbnQgY2lmc19m
bHVzaF9mb2xpbyhzdHJ1Y3QgaW5vZGUgKmlub2RlLCBsb2ZmX3QgcG9zLCBsb2ZmX3QgKl9mc3Rh
cnQsIGxvCiAJaW50IHJjID0gMDsKIAogCWZvbGlvID0gZmlsZW1hcF9nZXRfZm9saW8oaW5vZGUt
PmlfbWFwcGluZywgaW5kZXgpOwotCWlmIChJU19FUlIoZm9saW8pKQorCWlmICgoIWZvbGlvKSB8
fCAoSVNfRVJSKGZvbGlvKSkpCiAJCXJldHVybiAwOwogCiAJc2l6ZSA9IGZvbGlvX3NpemUoZm9s
aW8pOwotLSAKMi40MC4xCgo=
--0000000000008bb767060eccf210--
