Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E233386441;
	Sun, 18 Oct 2026 17:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792346002; cv=none; b=oQ5yYVq7UYI1SUuUyh0kiNI3XT2YkKGCruIpx8Fph6iDZWOhHjJ8QpvvgZsISouDZBnPy0n5Lczd7QDggIfF1qW61r5tIX9DygSW/dNhr1HBRCwweqG/RCYVQWNVtpbtdHlbgir3RgWxpqXHMVI/LExv9mYeTQHlTv87R+OrukA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792346002; c=relaxed/simple;
	bh=Kz1VPOV4qv1wG/E6pWvic/WtOetgb3IprI9BDvawQ7Q=;
	h=Message-ID:From:To:Cc:Subject:MIME-Version:Content-Type:Date; b=Ou2t+Zazj2f2jVp8Dyq7BN0NWqH3KX2AuT6WX9MwxXieNQ0RgFOVlsgSsX4Alzc/ojPm3e7mZLjD8VvtNy0a3LunjMzWLVE8xAB/148LLGk4+Are98csJyuIefsUSq+ev3PYuv9+ewgm5IKeAtsMStgVyt8sbbr6Xm0ea00r9sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=jan.koester@gmx.net header.b=gdKvsNf0; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=jan.koester@gmx.net header.b="gdKvsNf0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1792345994; x=1792950794; i=jan.koester@gmx.net;
	bh=WVXijfHyJt1GPpKx1pPVWYDCIVc7IbPnnwBef/HnfPY=;
	h=X-UI-Sender-Class:Message-ID:From:To:Cc:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=gdKvsNf0QXXFGPvk29/AeOa/0irxmkcCZCQFoQCdzC802oCoomcG0zl1EmEavoY3
	 IrDtM5ZtWqnxhgI8ckuLpdMaS10gxwmz9dXmEz5hapJ17GFbS0x3nsKYJuveGyOev
	 QJg5LwVNxWeDDnIo9ArrxXh894k+O0wJL3V/FSYErJ2LnBFRik9RWtIgZRJ+7uTp4
	 XsNGOHLc6hOPZ01RRY93nWpJiIhfoz1KYhDHzyBBfURY2O7Poe+RJJH532+NHGKbJ
	 q40Oyinq6RFbOsLNlRCP86xG/4/QLLtmeAndv5zYmE669luB8aBFIvDd2EEtoUPwi
	 yWYrV3s0YTorUZHJSg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MBDnI-1xSzCO0U74-002nHm; Sun, 18
 Oct 2026 19:53:14 +0200
Message-ID: <1792343439.stable-7.2.ksmbd.jan.koester@gmx.net>
From: Jan Koester <jan.koester@gmx.net>
To: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>, Gael Blivet <gael.blivet@gmail.com>, linux-cifs@vger.kernel.org
Subject: [7.2.y] ksmbd: exempt FSCTL_PIPE_TRANSCEIVE from the generic file-id lookup
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun, 18 Oct 2026 19:53:13 +0200
X-Provags-ID: V03:K1:KUetevx4J0kGA6GTlKX/8bwl6g+5tNr++yOTj8n7tQHhYXCRqO5
 /IXpKA903/UXzU7Zzwwob6AinzcP85PjpQ5G1wjDyA4phhkOVmkaOSLzwmru5ejcKWaz4e6
 DsxI8MMIpXK319SeceeO3ide5MtfR4czOeKV4ZFCaWPVqm+tEwn/vlkvvC/pdLHhg1MgIIp
 2EiUY3N+aTg39+DFd1eZQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Y9BZvqWhO3g=;Dm/k8jCHiDx7FocdzAyKgcTMZAN
 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
 TeVuluiCIR1RWXeh2bxTQSzNA+wd2JXWy7OkP8=

Hi,

please consider this mainline commit for 7.2.y:

  a3bcea7c819a ("ksmbd: exempt FSCTL_PIPE_TRANSCEIVE from the generic file-id lookup")

Without it, smb2_ioctl() looks up the RPC pipe handle of
FSCTL_PIPE_TRANSCEIVE in the open-file table, where it never is, and
fails the request. Every DCE/RPC call over a named pipe on IPC$ fails
(srvsvc, wkssvc, samr, lsarpc), so clients can't list the shares of a
ksmbd server ("smbclient -L", Explorer's \\server view, Finder's
"Connect to Server").

We hit the same bug on 7.2.9 and carried a local fix for it. The
mainline commit applies cleanly to 7.2.11.

Thanks,
Jan
