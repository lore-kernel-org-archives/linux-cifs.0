Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAEF42AA3
	for <linux-cifs@vger.kernel.org>; Mon, 13 Oct 2025 11:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760356279; cv=none; b=JtszLYEE7SpsVQHO/kot+roFBUASyOOqbiapOF48Q8uWur8X2w5B/HgnHOLdY2spZntrIYBbNPd4wOhwGipXM4Cl2swVu9YYAOzQez6iLRsZZF8OT9Y8oUXmvhYXMwY1sRREwp2Sx6eu4FeMMqTblY9P6C+Vi/z3RdQHhpIouPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760356279; c=relaxed/simple;
	bh=pFwwl+AaeLgXkWWCNRmOEpRcZ/pmVUNXMpbivar3VBM=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=tVcB4wEpoTb7yVleI182qX5LDnQ49WKuaMH6EpesnPXTCuCCoyM0cfYiR9/c1TS4wqF9G5a66FI7BXurVpd8McLpLvOpHiUYJPmVzCYQlBQpnAy/cefsHO/g3uf+/X7Hj3SaM3HjSAmbc+T2e9QvLdtfL4RgSjj2fc2+7rtRfio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=nZJLPihh; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="nZJLPihh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760356267; x=1760961067; i=markus.elfring@web.de;
	bh=FTFLA4DVe5wFKmXi96doMcwrcnmt/gIX0UTd0t3JT6U=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:From:Subject:
	 Cc:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=nZJLPihh685lBp2bk9PQ17bwJXxI/MfTSx0iZKAYdL/QtkeWCjvpDv63OeqF18Hx
	 HJRqyLlhlw9/1TkRdzPePFTVn9OF4Lmqb5jzEJAtGZg/R7kpBB1tZEjdTb9ILmaD1
	 oQ06cQIbCOGQ3xmziUTjbpvbzYW+RJVc5GiQYSGBBnzjIGg3d2UDnFPlMXXPUsiI+
	 amxFxXkd1ViGa1OYs9BNe7qBc5rzdUxyt8nUYiuYV7ws3vgAfakuYDQud8I2mvQJ1
	 cLDF2mHBtE9JcmgLuXv7wPUr5CiDnCZhzZ1hlGlfLjlKzmUgQjGWpOmIj+DQjt19J
	 50V+1lpa0gT/nYjkPw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.186]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MxHYK-1uJUsV3NRA-013yW5; Mon, 13
 Oct 2025 13:51:07 +0200
Message-ID: <335b0fe9-313f-4e3d-a01d-1954f3c46489@web.de>
Date: Mon, 13 Oct 2025 13:50:59 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: cocci@inria.fr
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
Subject: =?UTF-8?Q?Improving_source_code_parsing_for_=E2=80=9Cfs/smb/client/?=
 =?UTF-8?B?ZGlyLmPigJ0/?=
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:iE4QlOACSOEQNSw9ayAiuCQEeOpsoWbQk5x8U5RJBk87QyOrYYu
 5xOsoYhFh3dbOK9wjld450Gm4Qu08Azj4vLFCBzXPkc/mISbAE/hSzeff1lMCpUlB/5cvOG
 GLh9MhER96qwfY7GcPUlJrY0bodocci7+I5b9/T8rYR6B2qA7FXJ4gaUrqDqeG2wHbptctU
 CYZsH2HMRa+sHMcWKUKYA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:5kw7TP+E4Qw=;1jZOJNGJ4XRCS1OW1YKVUJJfsi1
 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
 ZrzQg==

Hello,

I would like to point another questionable test result out
(according to the software combination =E2=80=9CCoccinelle 1.3.0=E2=80=9D)=
:

Markus_Elfring@Sonne:=E2=80=A6/Projekte/Coccinelle/janitor> /usr/bin/spatc=
h --no-includes --parse-c fs/smb/client/dir.c
=E2=80=A6
parse error=20
 =3D File "fs/smb/client/dir.c", line 964, column 0, charpos =3D 25270
  around =3D '',
  whole content =3D=20
badcount: 283
=E2=80=A6
bad: static int cifs_do_create(struct inode *inode, struct dentry *direntr=
y, unsigned int xid,
=E2=80=A6
fs/smb/client/dir.c:211: passed:#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY=
=20
fs/smb/client/dir.c:280: passed:#endif=20
=E2=80=A6
nb good =3D 679,  nb passed =3D 7 =3D=3D=3D=3D=3D=3D=3D=3D=3D> 0.72% passe=
d
nb good =3D 679,  nb bad =3D 283 =3D=3D=3D=3D=3D=3D=3D=3D=3D> 70.79% good =
or passed


Under which circumstances will data processing become better supported for=
 such files?
https://elixir.bootlin.com/linux/v6.17.1/source/fs/smb/client/dir.c#L178-L=
455

Regards,
Markus
