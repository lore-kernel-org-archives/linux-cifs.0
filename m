Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2482171AB
	for <linux-cifs@vger.kernel.org>; Sun, 12 Nov 2023 19:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="JCYuUBs/"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BC19D
	for <linux-cifs@vger.kernel.org>; Sun, 12 Nov 2023 11:32:38 -0800 (PST)
Message-ID: <e6858b64b018b07d861c0c2c45dc2a41.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699817556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3rWQfLw68vfnlROz6OW/TpEvVMHNyeFByj3/CTw9LPs=;
	b=JCYuUBs/p5edPL2ZB4lhGOwqUuwg6w8jKfVlAEh/eplfnHk7Eg3jqXBZAkxkRbjktFPFeB
	R8cYbMmRZsTe/3ojkeOLW+uklC4a7SV8vQJXIEHG7f5kl9JF/L9d7+QjsQQ9HK6Wq/4xKY
	QIC1nuKG/UOW2ZrG+6O4pZytn/2yfS0e+T+4VNw3N8QdsHcVqfbfsOcs4SbgIcRMyV3vOi
	izEvDV/cbXwzQtvzTCwh4TZIeFZr79qP6LQ4pzSiUpXhhmRQJYJjFHmb3wpXDeICwSN4ug
	C3xPiRt/aJ+YGejiXqUHG9vltO4vE+uvCo+4dPtll3JwBlC6G1WSv5fhfLQIMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699817556; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3rWQfLw68vfnlROz6OW/TpEvVMHNyeFByj3/CTw9LPs=;
	b=lIe7JHJGXre+/tlGnqKxLA6Yv5Cg1GicrvaGkSdkTroxpmqIXfZPtandkCWuuhCmRiImbH
	BYP1nwKcy1+/dqOVU10s2mf8PD/NzDfUHZaRYTPtnQ3bvbqyRyJzUMq1Lj7Ooa7eJDuHGh
	VjbxHSkYWa/fBEnPl8HAOLAjOBRAIvJo12QTB9vUvZkmiVlbYuYZY9gybFT+9fZjP5rf12
	caNB3tSW1SQ9fIt5VbFv6S1zdunh5NIpNanyk8BeOFEZIuj8ZiC+JFYQQCuWawRiXRCurD
	nqmTVGsRJaqMESq9M7cQT//B3TD4yXM0cpfGV/zbk+W9RsBn4Q6YF9lxC9LhxQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699817556; a=rsa-sha256;
	cv=none;
	b=gnOfB3S5AaeOLOY85Fd+7K91hAS9/dYdLK/R7h+qIZS0sdHRmTF4ktBELqEC6uFyEP8LfA
	rj2a3bGCkAPCdKE3CZvrPXae013h/awzrYKUaQXzlo+zKoDFIbrPfXSKa5lWotjJ/iSQ7q
	hSPv2CkG1aDlw4Fm6pGzMO8AXulLodv/CSwjskqoKF1UwOTVPWRZeFrvpNszgYREs078bS
	GI5Oi6/kATDFI+FxhGay1PxJLkMPG5mjDrSc125tJrcHdaXgcqSI1zHOFP648bMpL+AV4s
	yUEX8/8udZRYZaq17cU7NfKe6CzAxCv9rpxAkkcnXL8Zne4R6sb8dtO7k4BnWg==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, bharathsm.hsk@gmail.com,
 linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 12/14] cifs: handle when server stops supporting
 multichannel
In-Reply-To: <CAH2r5mvG3zLBxknPOuaz9=GarZO6n6bhcduiZHHfiqVYZYJiVQ@mail.gmail.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-12-sprasad@microsoft.com>
 <5890a4eec52f50b271ba8188f1ace1c9.pc@manguebit.com>
 <147809311fa1593993c7852e32fa52fd.pc@manguebit.com>
 <CANT5p=pawpExEBXp93rK-kmoBPRY4QDMiyXvDCv7Ug0_vrxUPQ@mail.gmail.com>
 <abf890046207efea833cf9f5f9d589ab.pc@manguebit.com>
 <CANT5p=pJ5cXB+U3Zk=V_1Kzt5pkVidmgBZ_rxqmd1-Nisc6-NA@mail.gmail.com>
 <CANT5p=p=HC_Bkc57JxE3UDeDXppw7UNecw-iG62v-9GWGnq8Aw@mail.gmail.com>
 <c60ef5a6fb20a59ad7c4979cea5aa4d2.pc@manguebit.com>
 <CAH2r5mvG3zLBxknPOuaz9=GarZO6n6bhcduiZHHfiqVYZYJiVQ@mail.gmail.com>
Date: Sun, 12 Nov 2023 16:32:32 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> I tried reproducing this to Windows (a little trickier than I expected
> because I had to block the IPv6, not just the IPv4 addresses as in your
> example).  In my example (and built with the stricter kernel config you
> suggested) I do see expected warning messages (although puzzled at first
> why server name is blank in some debug messages - although I did mount with
> IPv4 address not hostname).  After reconnect I can access the mount and it
> seems to work fine.

You could also bring the ifaces down rather than blocking the specific
IP addresses.

I'd expect to see the other warnings in case you have lockdep and
CONFIG_DEBUG_ATOMIC_SLEEP=y enabled.

The blank hostnames are due to secondary channels being reconnected as
we only set it for the primary one.
