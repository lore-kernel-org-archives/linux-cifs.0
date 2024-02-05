Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FE413A877
	for <linux-cifs@vger.kernel.org>; Mon,  5 Feb 2024 20:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707166484; cv=none; b=mpnpBZuNqO2dY7QTUo/ZlQCGnaDpWLYccC4UUNs19uV+GE6S2Wm43gR2JNVLGYrd8JRaPaJgXrN+pn/oNipmT345xflQVNKpMVRuBn52ptf6Ei6nOjBi5TdANG+fvcVQs1CHRJqk+ORg4g26EWUXSqHmg/gjZGjl/AeWGT4kO7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707166484; c=relaxed/simple;
	bh=6hLNk4p1KRII9P6PC0lI1AtY/n/DPyRv+vPndiPep/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jGruD9WPfzQcao3mnasPN9p+ui+hhmbYOvYogvnYjoVTOZCKMMPJ2hUPnRrJ8pzzLfMD+m6mmqHZkeJH8yedJUUUr21fHL89IjhBOxyFpYgqdnQGdkvbOcHEYOyDAHJ0e7qa/rnDS7ZAN8CLWFjrymFflUa30C1PKLoPxCicHls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nga/rylj; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nga/rylj"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5115744dfe5so426829e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 05 Feb 2024 12:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707166480; x=1707771280; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BnJSR0bQOaMziHWyVwo+In+bP0caTb/Kri3L6TTzsGM=;
        b=Nga/ryljMOe69DlMCS54h9qQDJkYJkyCeLz4UmMmnQrmnOxHxf2Wt+G8O9Dnzu0Pfj
         tdj21abvZVXnpm7R3UQFlVogNu6x3kYqmegbzl2Aw6PG6G7GCBXpkrZbyyv7DAlrwfOf
         kQSly2IHyGd0UGn9T32GbXq2qzV6W2xSjezL0+YY4YU2pjN2SsDbeE7VxAklhQ0ad+wA
         oSfuxIvmMcvdqS5QwZJ45mH1IWiqCYoX1JwivClD0rj4N+/Cu4Yh5kZb7vwDcoNTS6N3
         XAleF+po8bxAqv3kAsjBoZRlHG539Bi5BUaFSA62yz0MnIiv1/nID1ajNNR2oiOx9oYq
         pWTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707166480; x=1707771280;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BnJSR0bQOaMziHWyVwo+In+bP0caTb/Kri3L6TTzsGM=;
        b=J8A3/BezbiEDExCX0YQrZ6Z4Aj3M/xAS1RB0HPAYrPN4Rm92HooFUn1Je8McExtwxp
         XfNRPXGsSQSTCwU47GAWh/+sILo0bmrWhF6GKeY1/GbdWrY8VzOOkKjXlglj1hCj4k+h
         q1c6VAOeT1P3qGuexKqN6LKKIJJk9pO4Ksz9Fg6o2i4yuNdf8xuCZ1oKHjdfA31Fc3RQ
         Pez8YE6cY1oUR4zPamqaWzH1gd+CNLu//yOOH+4LNlhdrrq9yXD2tIrVu2n3aR1x5XPO
         0n+JKQ30UEUggz8fG6dxL5RAzTubkcql81C4wkCIxGq5zD4T41L8kfkbEjmXZHnv1p6U
         2T2g==
X-Gm-Message-State: AOJu0Yw2XwAvqZFiQR+8hYcTSaxRaWy8rqzQl35DK8LRIWHuVy3wTmSZ
	Va0JFppx+t21nMI0Ah8Fx0sBlyqtpPKCKnTs+NEV7RmmvVQZ4b6ivVI/rCt5UL+aRq2CHU0W+vC
	JKsuVqAbqNTu/KuS51Ctg7YMZQ/c=
X-Google-Smtp-Source: AGHT+IEsv11OASS8h8kdH061TFLjKXQXgbneaxiCPuWpzdauV6AiMWHmeRHkdIVJ6ZHaRi5hEjyFPDl6UEiu0zW2r18=
X-Received: by 2002:a19:f805:0:b0:50e:ac97:8bbe with SMTP id
 a5-20020a19f805000000b0050eac978bbemr509760lff.45.1707166479731; Mon, 05 Feb
 2024 12:54:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <84dddfd9-c8d3-4e68-a228-f599649c8e8c@moroto.mountain>
In-Reply-To: <84dddfd9-c8d3-4e68-a228-f599649c8e8c@moroto.mountain>
From: Steve French <smfrench@gmail.com>
Date: Mon, 5 Feb 2024 14:54:28 -0600
Message-ID: <CAH2r5muqs2JFqECJY2R+0AEF4Y_ofdN8Wb55TH8UpfXU7L1ZGQ@mail.gmail.com>
Subject: Re: [bug report] cifs: do not search for channel if server is terminating
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: sprasad@microsoft.com, linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000098e4a30610a8abf9"

--00000000000098e4a30610a8abf9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Shyam,
Let me know if any objections to this fix, similar to what was pointed
out by Dan.

See attached.


On Mon, Feb 5, 2024 at 2:52=E2=80=AFAM Dan Carpenter <dan.carpenter@linaro.=
org> wrote:
>
> Hello Shyam Prasad N,
>
> This is a semi-automatic email about new static checker warnings.
>
>     fs/smb/client/sess.c:88 cifs_ses_get_chan_index()
>     warn: variable dereferenced before check 'server' (see line 79)
>
> fs/smb/client/sess.c
>     78          /* if the channel is waiting for termination */
>     79          if (server->terminate)
>                     ^^^^^^^^^^^^^^^^^
> The patch adds an unchecked dereference
>
>     80                  return CIFS_INVAL_CHAN_INDEX;
>     81
>     82          for (i =3D 0; i < ses->chan_count; i++) {
>     83                  if (ses->chans[i].server =3D=3D server)
>     84                          return i;
>     85          }
>     86
>     87          /* If we didn't find the channel, it is likely a bug */
>     88          if (server)
>                     ^^^^^^
> But the existing code assumed that server could be NULL
>
>     89                  cifs_dbg(VFS, "unable to get chan index for serve=
r: 0x%llx",
>     90                           server->conn_id);
>
> regards,
> dan carpenter
>


--=20
Thanks,

Steve

--00000000000098e4a30610a8abf9
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-missing-null-server-pointer-check.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-missing-null-server-pointer-check.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ls9eu2np0>
X-Attachment-Id: f_ls9eu2np0

RnJvbSBhZmI1MTFiZTlkZmIyN2ZmNTdiOTIxM2VmNTZjMjY0ZWFmZjZkYjM0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgNSBGZWIgMjAyNCAxNDo0MzoxNyAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGFkZCBtaXNzaW5nIG51bGwgc2VydmVyIHBvaW50ZXIgY2hlY2sKCkFkZHJlc3Mgc3RhdGlj
IGNoZWNrZXIgd2FybmluZyBpbiBjaWZzX3Nlc19nZXRfY2hhbl9pbmRleCgpOgogICAgd2Fybjog
dmFyaWFibGUgZGVyZWZlcmVuY2VkIGJlZm9yZSBjaGVjayAnc2VydmVyJwpUbyBiZSBjb25zaXN0
ZW50LCBhbmQgcmVkdWNlIHJpc2ssIHdlIHNob3VsZCBhZGQgYW5vdGhlciBjaGVjawpmb3IgbnVs
bCBzZXJ2ZXIgcG9pbnRlci4KCkZpeGVzOiA4ODY3NWIyMmQzNGUgKCJjaWZzOiBkbyBub3Qgc2Vh
cmNoIGZvciBjaGFubmVsIGlmIHNlcnZlciBpcyB0ZXJtaW5hdGluZyIpClJlcG9ydGVkLWJ5OiBE
YW4gQ2FycGVudGVyIDxkYW4uY2FycGVudGVyQGxpbmFyby5vcmc+CkNjOiBTaHlhbSBQcmFzYWQg
TiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0
ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9zZXNzLmMgfCAyICstCiAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQg
YS9mcy9zbWIvY2xpZW50L3Nlc3MuYyBiL2ZzL3NtYi9jbGllbnQvc2Vzcy5jCmluZGV4IGVkNGJk
ODhkZDUyOC4uNDc2ZDU0ZmNlYjUwIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3Nlc3MuYwor
KysgYi9mcy9zbWIvY2xpZW50L3Nlc3MuYwpAQCAtNzYsNyArNzYsNyBAQCBjaWZzX3Nlc19nZXRf
Y2hhbl9pbmRleChzdHJ1Y3QgY2lmc19zZXMgKnNlcywKIAl1bnNpZ25lZCBpbnQgaTsKIAogCS8q
IGlmIHRoZSBjaGFubmVsIGlzIHdhaXRpbmcgZm9yIHRlcm1pbmF0aW9uICovCi0JaWYgKHNlcnZl
ci0+dGVybWluYXRlKQorCWlmIChzZXJ2ZXIgJiYgc2VydmVyLT50ZXJtaW5hdGUpCiAJCXJldHVy
biBDSUZTX0lOVkFMX0NIQU5fSU5ERVg7CiAKIAlmb3IgKGkgPSAwOyBpIDwgc2VzLT5jaGFuX2Nv
dW50OyBpKyspIHsKLS0gCjIuNDAuMQoK
--00000000000098e4a30610a8abf9--
