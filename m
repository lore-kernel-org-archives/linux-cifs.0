Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06A09461
	for <linux-cifs@vger.kernel.org>; Fri, 21 Mar 2025 15:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742571511; cv=none; b=nAMPHaWEN2PBjBy1nGuDRbnzUraW35dOXg/r8vlcT7UwLkPH7yUdvNHVi7tQjV7IAiaokF3tPAbAnNCo3sYVN5fXLGO93KrRh3bqJLHKr6fbL48F5oczkTyUMxuX4pb1v+922To1TCZcTphA4pgsRtCTyXduli1exDJIm3f856k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742571511; c=relaxed/simple;
	bh=cPQbVQAe4kpObKQgjS0qJXwQpnGboODAu+VyPPEnSag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ptkief50AyLxJBH6NbuPD2fNKaiE2rzw24S4Bomx9B2TNjxjDdqCvlIbJJdYbUO6qxKgadIevf6NkZgYzCMRujHgSnq6t8jdhK3Ay9IWU8sDiVzZ/QdJYpECOLoGArZ12cAJxI1d7uPloodS96tmhEhARgxvAqZyAuiv6PElpTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kGQ+cm9x; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kGQ+cm9x"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-54991d85f99so3416733e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 21 Mar 2025 08:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742571508; x=1743176308; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cPQbVQAe4kpObKQgjS0qJXwQpnGboODAu+VyPPEnSag=;
        b=kGQ+cm9xGIypggJUq5Z31AZKRgu507uuu/X7XUZRv+k7m1yvnnurS/QJzqMSodE8iz
         mC3uFEBb22YKgb6Z57zwdZT/5hnf+nRhDMmPref41K2itl5BKErOcPLokCA1kuxhk467
         RzR9S44p2H12TtTo9JXb1/ljqnly7CbR9Vh0Wau92s+fUAMwOyISHdSnhMv/267llj/Z
         M3qxtdjAagpuH3SRMTSP+m/Z/MqdnjLaA3xdFhRJr1Ut3LGRORmkLlqxi3vc4CdfZoUD
         6a/YVwiPejc/svFDA+UQfQ+CBGatroMEq+pFQuS4WDccDoif/UGbSh6szR3nNi+jV483
         Fsig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742571508; x=1743176308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cPQbVQAe4kpObKQgjS0qJXwQpnGboODAu+VyPPEnSag=;
        b=Ik38IepqF8d+O8kYDzubfiVyho/HEJHrrmMtCmBFkMmkJ7rMQfzgZwzk8aJGzk1D1p
         i3C5r5eiV2ht8H3ZGMweP19X1bmZav5xavUnxPmDr6VuyBcuTv3c6cHlMwwp+jCTj0/K
         SoDZkXy79YcFz7VOya6Jm096dS5cxr4c3VubabAZ6NmNQdMNh4nK9yL3JKQt/nDRb08W
         unMSlLKHHMTmoEmSLf0RIQS+CO6JCgSyWlEo8SFPWg8Rk2vh9nhgJkFomuJYrdvLG6ix
         R3OOpqDH6pFQJWhOIT7mCKrjGEi/H76pPVZRP7S6s3e25eQop4gg640P/5YeY0kdTMx8
         Fm+Q==
X-Gm-Message-State: AOJu0Yzc95K9YrPMjj9uxyxSrqlFM20H1uljcL3K5KDTb0DaYBODlmP5
	u2wM1sNZUUegCD1LsY80AA/2Tw1HVKhXzFGbzq73CsbBPwr2IPCCKvEK1XNXlCGuvx3ZAlJiVXp
	mqJ6CEdkzFw17Lq8P3Aipongc6EDd7g==
X-Gm-Gg: ASbGncuN5FFad9J14gyLHwVDL/mRHMcop851/+OHJs8/4sggWp19JMZJlYbllrG/ruH
	5GDb13xbni0DYdAmKvCQWL3Gv01EwljV/5hL0nxPPE6mV5ZlplhzZD1xDL8ZrqNfltHu6K3M69E
	MXaqxuJ1NxQxUHwyFa379WxO1f8KS1lpoJ8DytNOcjikcffKNfM48iNuLIOXCt
X-Google-Smtp-Source: AGHT+IHgjizqvJ5D5ucxqv/Mwl4zHn20M/EtYgCCPtv1uMmiOSyQbw3k81lRDRK90+C9abij05LOQCV9fBhxiL8xb10=
X-Received: by 2002:a05:6512:3e21:b0:549:903d:b8d8 with SMTP id
 2adb3069b0e04-54acfa8632emr2455205e87.8.1742571507536; Fri, 21 Mar 2025
 08:38:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muHk=mUQo_SPk3DdzC7=0VCNiS3fDtotHxYUkT746RP=w@mail.gmail.com>
 <3211936.1742554325@warthog.procyon.org.uk>
In-Reply-To: <3211936.1742554325@warthog.procyon.org.uk>
From: Steve French <smfrench@gmail.com>
Date: Fri, 21 Mar 2025 10:38:18 -0500
X-Gm-Features: AQ5f1JpZqbjqRBm-YOxecXPebfXOmQHY_RBOuLoQcBrLORD4MqtCwN87cej168Q
Message-ID: <CAH2r5msyT3cMEVyNDn4B2m=v7XTJ9btcoQRO3Gm-uCgx9OW0HA@mail.gmail.com>
Subject: Re: xfstest results
To: David Howells <dhowells@redhat.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 21, 2025 at 5:52=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> Steve French <smfrench@gmail.com> wrote:
>
> > But with all six current netfs patches (including the two additional be=
low):
> > 68109110fec1 netfs: Fix wait/wake to be consistent about the waitqueue =
used
> > 4f8443992c8c netfs: Fix the request's work item to not require a ref
> >
> > http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builder=
s/5/builds/404
>
> The server is currently inaccessible.

I have restarted it, it autoshutdown last night



--
Thanks,

Steve
