Received: from mout.freenet.de (mout.freenet.de [194.97.204.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA263E2AB7
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 15:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.97.204.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782488725; cv=none; b=cwJfi7lkWnX4Zz2Hjsqaux1vB82BQzC2AjLq9CAOUk1Q3EJvvZLuIHW6E1F327r283n9ZcOAxvOCM6ym4NSE5vqeVjKdZjqQtcS6oSPN43vFwYls3pQedcg+x5hpnmYywO3vU6XXns/s5ztUBrC1Hzb7ohEzA6CRuzzUU9c5NPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782488725; c=relaxed/simple;
	bh=dkNUFKbJ2KuJq8Wr0J4GpoQ9RQckpapCkp+QB8yujQo=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=npyAS2hi904DXR3OtE8VWg0Q5KLwyUOeMG89ID/5mpLgKvuPAlcTjFGT7bZlDZXURQkrn1gnDIsjc6qfoKtMEuGNNvjkh1UjpA6C3PpARLDpScgb7bZzPi8QQNcv0GmYGqUpqc2jw2gUZ9vgEuZ2CDjSXd4S+r7K2StSrLsQEaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=freenet.de; spf=pass smtp.mailfrom=freenet.de; dkim=pass (2048-bit key) header.d=freenet.de header.i=@freenet.de header.b=F1JQa+RW; arc=none smtp.client-ip=194.97.204.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=freenet.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freenet.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freenet.de header.i=@freenet.de header.b="F1JQa+RW"
Received: from [2001:748:400:3319::5] (helo=sub9.mail.fnrz.de)
	by mout5.mail.fnrz.de with esmtpa (ID m.u.farber@freenet.de) (port 25) (Exim 4.98.2 #2)
	id 1wd8eg-00000007tYI-1h6S;
	Fri, 26 Jun 2026 17:39:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=freenet.de;
	s=mjaymdexmjqk; h=Content-Transfer-Encoding:Content-Type:Subject:From:Cc:To:
	MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References; bh=j1qPErTR9AhOZby98zj9VtjPRl6KNQYdCdnj6ZBWcQY=; b=F1
	JQa+RWMKRZ0k4x2Z2psQh9WqC7qMvtyvMOZlMGXN4tk6z8QHPMV7ut13G5yfeZLttCh6Me/BXeKgl
	vHnJ0IpvOHP7in3cWH67vzwGIVZL+mnAtvt6rO6mabohaF6tldrWBH/G4C/o1dtItwrn378cED6hp
	99Y1zq/2ChCwUdg6rbvabGUszWg8OWRZE1YSSKEfiPrJziN/0EMV6orTGW7KhkluSiyuQluXWshDR
	/cV8tpG7WpUc1l189DKyhVyMZLLP4R+nr2U+67xWLY664qKEcLIoDac/nsyJdm+u6365EZs4vJYv8
	zlLNWifTLXUEKATGaKer49y7LDkoY27A==;
Received: from p200300e9b721a7007a1edb211677b872.dip0.t-ipconnect.de ([2003:e9:b721:a700:7a1e:db21:1677:b872]:52696)
	by sub9.mail.fnrz.de with esmtpsa (ID m.u.farber@freenet.de) (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (port 587) (Exim 4.98.2 #2)
	id 1wd8eg-00000001NEl-16Ur;
	Fri, 26 Jun 2026 17:39:46 +0200
Message-ID: <4a88b87d-c38d-4248-a3c3-59dd8c1f5095@freenet.de>
Date: Fri, 26 Jun 2026 17:39:45 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: de-DE, fr, en-US
To: linux-cifs@vger.kernel.org
Cc: sfrench@samba.org
From: Max-Ulrich Farber <m.u.farber@freenet.de>
Subject: BUG: SMB3.11 POSIX extensions: Absolute symlinks lose leading slash
 on creation
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-FN-MUUID: 17824883861D85364C5069O
X-Scan-TS: Fri, 26 Jun 2026 17:39:46 +0200

Hello,

Here is the bug report:
--------------------------------------------------
Subject: BUG: SMB3 POSIX extensions: Creating absolute symlinks from 
client strips leading slash

I am experiencing a bug with the SMB3 POSIX extensions ("smb3 unix 
extensions = yes") where the leading slash of absolute symlinks is 
stripped when created from the client side.

Steps to reproduce:
1. Mount a Samba share on a Linux client with SMB3.11 and POSIX 
extensions enabled.
2. Run the following command on the client:
    ln -s /media/Raspi/Test/Reisen /media/Raspi/Reisen

Expected result:
The symlink points to the absolute path:
/media/Raspi/Reisen -> /media/Raspi/Test/Reisen

Actual result:
The leading slash is missing, creating an invalid relative path:
/media/Raspi/Reisen -> media/Raspi/Test/Reisen

Additional Info:
- Symlinks created directly on the server host work perfectly and keep 
the leading slash.
--------------------------------------------------

Server: Samba Version 4.24.3-Debian-4.24.3+dfsg-1~bpo13+1
Client: Kernel: 6.12.94+deb13-amd64

Best regards,
M. Farber

