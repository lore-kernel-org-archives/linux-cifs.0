Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D109D529
	for <linux-cifs@vger.kernel.org>; Tue, 13 May 2025 02:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747102509; cv=none; b=oliXOFOzRQaUaAVMkimc65XRLkhdd54TltCKFR7IKzP+G4890VNzVwuJnffNFWsJMr3cUVuNCnYaBprrSyw0I0y2tJbNGeNDKLtm5zpOkWn+tkdX+TBFDNCCx7oSIvKKVAPuO7K97oJHrS3P4eDI34kKiR/wJVOrK9D2MGL4LlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747102509; c=relaxed/simple;
	bh=UV4hQj5mYkYQ7tGiz3XrAlEnXhTtQSQzIbVOc2f+LFc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=t8l6elcPyupyw9KqIUR5bR3Yq4hwd5+32lczCTc0GQLukU7sySS3VJFJKpanI5qsbbUaON0gLQ7KUChiXcJ4XkA/b2CJqPQxIDgBt2L/aQBSmMSElXUxkj2AX46DdFysrzVjB7dWpPLXPYKN3DIpU7DqcyKqnCHX639KSOsXZFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WupipUb5; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WupipUb5"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ad23ec87134so420294766b.2
        for <linux-cifs@vger.kernel.org>; Mon, 12 May 2025 19:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747102506; x=1747707306; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2P4eVEUPLmYXLZY79FIW6EgfFkUUllc9oJO1uUpzKSQ=;
        b=WupipUb5JsfvIgbv11fje893Gk9ube/Z62kPPbi9rlhinh6FrBlT08Evl+oHE0Jsxp
         HdOsrtTILxOj3FLIldLoM2TQy0dt7pNY2NlGJZl0JdgzKKlszeyEx1e6sKMciPasAotD
         mpBt/1paZGggG+7/IdskxkRZYBFHpDTYndlXylU3r2/c5GhxW9/oGLYyz+iF7aiiJszs
         0nhtvYziyLC9/jzBx1QwvqYVSxSuy80VZb8tuiMwnv0NPwW6My0gwFokQ5woORcyfpFg
         /hcP4wdK3ar+tMIdDIf6u7hHBsiB1XeB2Rx+mkMsJIUU1ogHWGSv3uRrfsWuidcIJ4Lw
         R12g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747102506; x=1747707306;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2P4eVEUPLmYXLZY79FIW6EgfFkUUllc9oJO1uUpzKSQ=;
        b=bvpFxfKUa/z6SSanAfkmnVIxXhOU+S1SM9qTrY3tOBsSek7ka+Pk7TdkLAZHr+6iZL
         ynDYiQ1fyghay9A4r7S1MWEqQ0J9ZGr3ZhLbTz5BmMvtvGNJbKRUpRSvzbort+FCC3LN
         jidZZzH5KaiZjfMJjJxK5QMcVfjmE2lMNs0CGfeuqaohidDOOl/rE0rhjKoFMidmIxyW
         XDiingx9hZysB1AWYKNijodT0L5zYURJGGBG4W/fHqQs+xrFejGWyPxY4DfnZj986Byf
         WwQTSBrKeAnuhH8Jc5D8olboFvV7gkFz9cSdirncR0mik4ppCn48gcKSHQ0VAbiy6lz1
         uscQ==
X-Gm-Message-State: AOJu0YwWlcby8X5UNLdHZMVLiQjSCMnkI1PhOtrF5dMPi8mGnaXmB2bL
	CXAKn5Q0aUXGPwoKQ9cFO+CHK3FoU8Rf9ImAR6AtzbxYSWr2KlzYPgPt36oCsYN53dfyxZb7sEA
	2T591Oby+ufzshrUzcnOO2fkuhQZ2Pq8GM1BkSg==
X-Gm-Gg: ASbGncuJGxXeuGaSjkOamxhOcK1YUlEHrLpsxNsWNyD/V9hFvui6TeUIFg32R3na/T/
	3BlgBoF0exL7Kixs5SlPs9yIEZNeHf9yRMKD90UHx+JO1TNRqUjaU33V+7/3Kis8Lf3r2Nj9hzP
	b0uQb3hb/VAHta7VeTN4uyKmmzH8Wicfg9lQ==
X-Google-Smtp-Source: AGHT+IF49CvP7xlExjkn8MwV5VvNitEHl0KmieqwPS3lvJcPYN5u1entOytEIpQPjEdCO5wI0KT3UNG6ImR5SNqaOOs=
X-Received: by 2002:a17:907:3949:b0:ad2:4672:d1f4 with SMTP id
 a640c23a62f3a-ad24672d60dmr731290866b.2.1747102505701; Mon, 12 May 2025
 19:15:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALMA0xaVdk3qwkb-92QqF2+6z+=oxbBWDR1hYEoE2WUc7jVGkw@mail.gmail.com>
 <CAH2r5mvLwetOfEnoKLaEjsKbgzM_i54L2=9eq1q5oSAbitG4nQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvLwetOfEnoKLaEjsKbgzM_i54L2=9eq1q5oSAbitG4nQ@mail.gmail.com>
From: Zhixu Liu <zhixu.liu@gmail.com>
Date: Tue, 13 May 2025 10:14:28 +0800
X-Gm-Features: AX0GCFtSqAqJUg4x065Sx1iWdpQsmxNAv_i3e1-pNFXJopTxQqki-VAi36S9Q_Y
Message-ID: <CALMA0xYFaOP3QGDUPQwxeEi=jG-B6QdXOU9Y9LekKNnMiYy8qg@mail.gmail.com>
Subject: Re: [PATCH] getcifsacl, setcifsacl: use <libgen.h> for basename
To: linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000003d6d960634fb002a"

--0000000000003d6d960634fb002a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

cifscreds: use <libgen.h> for basename

fix another implicit declaration of function 'basename' in musl

On Sat, May 3, 2025 at 1:18=E2=80=AFAM Steve French <smfrench@gmail.com> wr=
ote:
>
> merged into cifs-utils for-next (and smb3-utils for-next in github as wel=
l)
>
> On Fri, May 2, 2025 at 10:27=E2=80=AFAM Zhixu Liu <zhixu.liu@gmail.com> w=
rote:
> >
> > basename() is defined in <libgen.h> only in musl, while glibc defines i=
t
> > in <string.h> too, which is not standard behavior.
> >
> > please see attachment for the patch, thanks.
> > --
> > Z. Liu
>
>
>
> --
> Thanks,
>
> Steve



--=20
Z. Liu

--0000000000003d6d960634fb002a
Content-Type: application/octet-stream; 
	name="0001-cifscreds-use-libgen.h-for-basename.patch"
Content-Disposition: attachment; 
	filename="0001-cifscreds-use-libgen.h-for-basename.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_malvnztd0>
X-Attachment-Id: f_malvnztd0

RnJvbSBhZTY0NGI1NmE0NDQ2ZjUyMGE3NTIxN2Y5Mjg4Nzc1ZTEyN2FiMmM4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiAiWi4gTGl1IiA8emhpeHUubGl1QGdtYWlsLmNvbT4KRGF0ZTog
VHVlLCAxMyBNYXkgMjAyNSAwNzozMTo0NiArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIGNpZnNjcmVk
czogdXNlIDxsaWJnZW4uaD4gZm9yIGJhc2VuYW1lCgpmaXggYW5vdGhlciBpbXBsaWNpdCBkZWNs
YXJhdGlvbiBvZiBmdW5jdGlvbiAnYmFzZW5hbWUnIGluIG11c2wKClNpZ25lZC1vZmYtYnk6IFou
IExpdSA8emhpeHUubGl1QGdtYWlsLmNvbT4KCmRpZmYgLS1naXQgYS9jaWZzY3JlZHMuYyBiL2Np
ZnNjcmVkcy5jCmluZGV4IGY1NTJiYzguLjI5NTA1OWYgMTAwNjQ0Ci0tLSBhL2NpZnNjcmVkcy5j
CisrKyBiL2NpZnNjcmVkcy5jCkBAIC0yOSw2ICsyOSw3IEBACiAjaW5jbHVkZSA8a2V5dXRpbHMu
aD4KICNpbmNsdWRlIDxnZXRvcHQuaD4KICNpbmNsdWRlIDxlcnJuby5oPgorI2luY2x1ZGUgPGxp
Ymdlbi5oPgogI2luY2x1ZGUgImNpZnNrZXkuaCIKICNpbmNsdWRlICJtb3VudC5oIgogI2luY2x1
ZGUgInJlc29sdmVfaG9zdC5oIgotLSAKMi40NS4yCgo=
--0000000000003d6d960634fb002a--
