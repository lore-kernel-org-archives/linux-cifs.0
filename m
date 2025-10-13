Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE44026CE37
	for <linux-cifs@vger.kernel.org>; Mon, 13 Oct 2025 12:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760357155; cv=none; b=CjYTKWjYs6dw+9wCXOUGSJO84OOtiL9c20alX8urGucOH2r9Y97pXHU0d2oYFNrdP0dqq6D408+lHS4IWYp4fmU5PSbKqCrGn66xqteMR54xO7lAW+lFxCQ/zkkapoNKXXlVg3c/MO0fphW1DeOs7/Q0+9RnE7X3Msi7BCjChws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760357155; c=relaxed/simple;
	bh=qH4PhBtfKo6VBNHdqO865T71M1Xg7CYDRjaIYHczsfk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=bqU1wfrmKONXcBSbdIU3tdzriTgENS5nPbrGitgnpk9i2LjH2FSF9fvqBsTjNtJqWPDA84WuZzHnU0Tk1f0FoYLyvvwfjLjUM/pIMYADtzF0t8DKPNOPDSnb9n9TYhQp68ByGwiB3prtuzszzqs9g3n7eq3bKi99gOGxSPGTGp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=VGWXs1zS; arc=none smtp.client-ip=192.134.164.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="VGWXs1zS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=jVZde6vu3Rjta6XdJlDh+HmMY82ohbH0K2r8RuARsOY=;
  b=VGWXs1zS1G3ULr4V/di9YI/CDhl+KgFucCUIH9mHqA1p9zfIgcr500Oh
   kXpV0/x2GA8LP2F80tf3O1zL5Oja7UQkGEQ3apSnbVzHsFKtYx3puzfRy
   9Kzi3jySNkC9XUNm3yZe65mJ+1CpgTYUUNKgd+UZotYO5rgcp/rS8J50H
   0=;
X-CSE-ConnectionGUID: Fpqw7rysTS+9II7uuyFAOw==
X-CSE-MsgGUID: /CxxsVvWQRWGPUoPGoB96A==
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.19,225,1754949600"; 
   d="scan'208";a="243881894"
Received: from bb116-15-226-202.singnet.com.sg (HELO hadrien) ([116.15.226.202])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 14:04:41 +0200
Date: Mon, 13 Oct 2025 20:04:37 +0800 (+08)
From: Julia Lawall <julia.lawall@inria.fr>
To: Markus Elfring <Markus.Elfring@web.de>
cc: cocci@inria.fr, linux-cifs@vger.kernel.org
Subject: =?UTF-8?Q?Re=3A_=5Bcocci=5D_Improving_source_code_parsing_for?=
 =?UTF-8?Q?_=E2=80=9Cfs=2Fsmb=2Fclient=2Fdir=2Ec=E2=80=9D=3F?=
In-Reply-To: <335b0fe9-313f-4e3d-a01d-1954f3c46489@web.de>
Message-ID: <805f36f6-ea15-cbc9-f510-45856eb6f6d7@inria.fr>
References: <335b0fe9-313f-4e3d-a01d-1954f3c46489@web.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-343112014-1760357082=:3281"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-343112014-1760357082=:3281
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Mon, 13 Oct 2025, Markus Elfring wrote:

> Hello,
>
> I would like to point another questionable test result out
> (according to the software combination “Coccinelle 1.3.0”):
>
> Markus_Elfring@Sonne:…/Projekte/Coccinelle/janitor> /usr/bin/spatch --no-includes --parse-c fs/smb/client/dir.c
> …
> parse error
>  = File "fs/smb/client/dir.c", line 964, column 0, charpos = 25270
>   around = '',
>   whole content =
> badcount: 283
> …
> bad: static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
> …
> fs/smb/client/dir.c:211: passed:#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
> fs/smb/client/dir.c:280: passed:#endif
> …
> nb good = 679,  nb passed = 7 =========> 0.72% passed
> nb good = 679,  nb bad = 283 =========> 70.79% good or passed
>
>
> Under which circumstances will data processing become better supported for such files?
> https://elixir.bootlin.com/linux/v6.17.1/source/fs/smb/client/dir.c#L178-L455

If you want the problem to be solved, please make some effort to narrow it
down to a smaller number of lines.  Like 5.

julia
--8323329-343112014-1760357082=:3281--
