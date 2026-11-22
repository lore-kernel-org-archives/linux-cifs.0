Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=116.130.217.65
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795329013;
	b=idfyc94vkoLjpQOsJCikEWd4fLYTlBnX419+cY76f6BNVFrrgAddtljo+2peOSgLN3Yv
	 XNix3rQ4wx6n1eDqA8+LNVwDoOF8nGeHRNw0risbimWuy9miy0zeUU9Yt1TiMOTFpYEEH
	 rGuBaq3fuNY/H2431AWqtGi1jIVUXXOngHx4xY6GKOT3SEr4m/HgPdCbxL3occNjv1fpC
	 ShWYH2brlZ64o7xiu6rvUu5grh964vxIiULsvE2KB0Px0i8e53n7A19yxlicZfd55zxm7
	 n02yL8uhUgxhqVUMrKJYGr6TLIy1q0mWKNpgHXPJCtQcWpZxd6+YYRZLjaBQ6Ik3DuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795329013;
	h=DMARC-Filter:Received:DKIM-Signature:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:To:Date:Message-ID:
	 List-Unsubscribe:List-Unsubscribe-Post:Reply-To:X-Sohu-Gateway:
	 X-Sohu-Antispam-Language:X-Sohu-Antispam-Score;
	bh=QQmXLk0FLuhpaOAbyKFJOa8BdgDej5+RwQl2PDz4cHo=;
	b=D4zobFUnjG4VNFsuaz9Qmsyj1HpiRswLOGDxcPZ7LGwygjEu48LWn7WQhQH3ZfdG8wdg
	 3csO8s7datqUvhae7gSPqmnjT3J6y3NH9ZmTlYCdi9mG2ngPTdXw+fyViIw4/VZ/bOOov
	 161F7Cm7xwnSDqFbQJGsq1RYtQsNOd+bkW84+ynvNgfznwX2C35cNOa87TUoQqPkvdAEW
	 6VkZ1/Oe6L9+M+R4NgUpoeDxkMNjVdF8VrT8oTQyakpGj3sFDubGrACBUNSiZv952OsFV
	 UzTm0wd0FnI4xV6LhjvJNxyLiTsWIl45EAmnsXmyndXCpHXmo27aGCTbwYbPlLKiF/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=sohu.com;
	spf=pass smtp.mailfrom=sohu.com;
	dkim=pass header.d=sohu.com header.i=@sohu.com header.a=rsa-sha256 header.s=mail header.b=uLeA4oSu;
	arc=none smtp.remote-ip=116.130.217.65
Received: from smtp217-65.mail.sohu.com (smtp217-65.mail.sohu.com [116.130.217.65])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3085E606A320
	for <linux-cifs@vger.kernel.org>; Sun, 22 Nov 2026 06:30:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3085E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sohu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sohu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=sohu.com header.i=@sohu.com header.a=rsa-sha256 header.s=mail header.b=uLeA4oSu
Received: from [172.25.140.59] (unknown [43.106.14.92])
	by smtp217-65.mail.sohu.com (Postfix) with ESMTPA id 4jXK1h3jDsz6v4F
	for <linux-cifs@vger.kernel.org>; Sun, 22 Nov 2026 14:29:59 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sohu.com; s=mail;
	t=1795329001; bh=QQmXLk0FLuhpaOAbyKFJOa8BdgDej5+RwQl2PDz4cHo=;
	h=Subject:From:To:Date:List-Unsubscribe:Reply-To:From;
	b=uLeA4oSuFSP04NyyRzF223v6N2pS8ioJeODTN8otRg1erYJ2zAFG2wU8TRzVvH9K1
	 T/4rQFTyq0iyZmbNihnkHqB/awC0AocGLYBZcRkYUzqu943p7fs+o3HC9picJ8/6NA
	 YrQeEmSumfPWyKN3HHAbE8iHVUvd1y9/usVXUUbo=
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Subject: =?utf-8?q?token8341_=E2=80=94_an_API_partner_for_your_project?=
From: =?utf-8?b?ODM0MVRva2Vu5bel5Y6C?= <wusohu_177_0979@sohu.com>
To: linux-cifs@vger.kernel.org
Date: Sun, 22 Nov 2026 14:29:59 +0800
Message-ID: <179532899984.2759411.12184505153297602827@sohu.com>
List-Unsubscribe-Post: List-Unsubscribe=One-Click
Reply-To: wuqiong@token8341.com
X-Sohu-Gateway: 1
X-Sohu-Antispam-Language: 0
X-Sohu-Antispam-Score: 0.01

5L2g5aW977yMCgrmiJHku6zlubPlj7AgdG9rZW44MzQx77yIdG9rZW44MzQxLmNvbe+8ieaPkOS+
myBBSSDlpKfmqKHlnosgQVBJIOiBmuWQiOacjeWKoe+8jArkuIDkuKoga2V5IOiwg+eUqCBEZWVw
U2Vla+OAgUtpbWnjgIHmmbrosLEgR0xN44CB6YCa5LmJ5Y2D6Zeu44CBTWluaU1heCDnrYnmqKHl
novvvIwK5a6M5YWo5YW85a65IE9wZW5BSSBTREvjgIIKCuaDs+i3n+S9oOiBiuiBiuaYr+WQpuac
ieWQiOS9nOWPr+iDveOAguWbnui/meWwgemCruS7tuWwseiDveaJvuWIsOaIkeOAguiwouiwou+8
gQoKLS0tCuWQtOeQvAp0b2tlbjgzNDEKaHR0cHM6Ly93d3cudG9rZW44MzQxLmNvbQoKLS0K5LiN
5oOz5YaN5pS25Yiw5oiR5Lus55qE6YKu5Lu277yf54K55LiL6Z2i6L+Z5Liq6ZO+5o6l5LiA6ZSu
6YCA6K6i77yM56uL5Y2z55Sf5pWI77yaCmh0dHBzOi8vdG9rZW44MzQxLmNvbS9nby91L2JHbHVk
WGd0WTJsbWMwQjJaMlZ5TG10bGNtNWxiQzV2Y21kOFpkNV9sSWdlCu+8iOS5n+WPr+S7peebtOaO
peWbnuWkjeacrOmCruS7tuOAgeato+aWh+WGmeOAjOmAgOiuouOAjeS4pOS4quWtl++8jOaIkeS7
rOWQjOagt+S8muWkhOeQhuOAgu+8iQ==
