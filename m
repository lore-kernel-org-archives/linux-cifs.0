Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F7886342;
	Sat,  4 Oct 2025 08:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759567561; cv=none; b=WDMBTEgy4Qz/ESbiGfAjTmfKOpXPESwZUXDLCgUtwh4OBOeWxtQkFIwbIjDC53AO3BspgYzIH67ixMvgQvZBJukdackvVnm9ddfh59FS1jo9W6bzL1ljqg7D5dEp6lX1i2UbmnAzrcTiQGwGV+5W7SZnzeuGg4ehBC+ryst+kNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759567561; c=relaxed/simple;
	bh=KE2PBqgtr1R2voBioWIHbwel/ej2jMYwTDhpJHHh2cU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PlnLL9xYTtaDEJgkMzpeeZt48ZoEA9sCsyNQ3oHcMf4v7wNeAExPYcwf0KXT77O99kJ1swbLw3WBgdZdNXOiqOrAKx0NH9k18VUKr4ef8pVr+xJv9I9v6XxLBSZSn/cth9lgTamlTQREVNRkwVDBBCzwawJMTkG2oLVeppMB6KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=vLapQ71f; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="vLapQ71f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759567537; x=1760172337; i=markus.elfring@web.de;
	bh=oiFWZwgE13+/heK3BtOCRly+uNdxnMzI7j9JbRtvT04=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=vLapQ71fd89ucYuy1t/EvLFhEg2NkXpPHMnA2sNBgivtQxMEjwxALluXjgzq2iiS
	 tw2gSk8a2TnETsJAK16EW9dSICeqo/uzg+ptHdw7U+CjfxqULIdL3Gjc1ukOijG25
	 HMRs2/Wt9v3alZ2nShAFwyCeIUwFK0AnF/0MVF8cc5IXRoNn88ulpzFtNqeAdxJDT
	 WbO6TuhhXL2loT3mXrSmkw61COWCibb7PPZmHK9nfQUaWt9Ex+YxyiiiXpohbPdyQ
	 pwIOC62+duEZTvR1M4IL4yf1rnZto+Z5sTD0f/4n+JpFeHJIe9jUauX/uOqctWBpI
	 Oz1ro7rcTgbFk5NlQA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.173]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MqIFD-1uS4Qc2qnL-00ptZd; Sat, 04
 Oct 2025 10:45:37 +0200
Message-ID: <2d533e64-8543-402d-9295-5fd2f314f35d@web.de>
Date: Sat, 4 Oct 2025 10:45:22 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksmbd: Use common error handling code in ksmbd_vfs_path_lookup()
To: Neil Brown <neil@brown.name>, linux-cifs@vger.kernel.org
Cc: Neil Brown <neilb@ownmail.net>, LKML <linux-kernel@vger.kernel.org>,
 kernel-janitors@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Stefan Metzmacher <metze@samba.org>, Steve French <smfrench@gmail.com>,
 Tom Talpey <tom@talpey.com>
References: <6d759211-79e7-4d86-b22e-2ae46d209622@web.de>
 <175953064635.1793333.2429881029964457140@noble.neil.brown.name>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <175953064635.1793333.2429881029964457140@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:GtmNObrEe2RGJ/TFAqKx+TLt+80qxeC7jspZaOsWDb+YuzXznUx
 B6xf2InLNW0SpT//CR3/WBuSoNinUtfTzMQbxJHTmZt03GwbWAgW9wevFvrzVHiwmUdDwfm
 ttcXlLnOEeK+Z3IQNR/NdBHlfLPVxLLG8bq//ZHjuCj4zbO4/P+7fbgH0iLDK3uqX2VyvKh
 vRgaEwa7UMl8fcG3MUuLw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:RnESL/q2QzY=;/xFdurcqhgIvh5lWB9Ub3C6u2Wg
 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
 LUfwAfMtKeWyMHTy1namkmGfldpj9S15AKM=

=E2=80=A6> - declare  struct path path __free(path_-put) =3D {};
=E2=80=A6>    return_path->dentry =3D no_free_ptr(path.dentry);
>    return_path->mnt =3D no_free_ptr(path.mnt);
>    return 0;
>=20
> This is based on the pattern in kern_path_parent() and
> __start_removing_path().

Do you propose that affected software components may benefit more from
the application of scope-based resource management?
https://elixir.bootlin.com/linux/v6.17/source/include/linux/path.h#L22-L28

Regards,
Markus
