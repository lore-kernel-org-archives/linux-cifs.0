Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="SCsPyga6"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA41184
	for <linux-cifs@vger.kernel.org>; Fri,  8 Dec 2023 11:07:46 -0800 (PST)
Message-ID: <ba42bcc91981af579d70a239f18ad810@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702062465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GGVDlKYmDU/1tbkuJjfbk6JvWhTSx4mOggBnQC67DWs=;
	b=SCsPyga6QW+c94qKKTg4prmv5oNebVXk6sAxMn9/QTNPsUd06a0jc7w5O687huSNABgfvo
	MY4M1oMIdgplri1uwPDJ5AH3vEw0D9+gPAXEqtbODFN7HGLdNfU7dw02zkTSxofU1y2fu7
	tZFbxZYGNRAbxhaHx8bzGFoKCmZWl0OBiWESbOOE7ZwXlU+fp+2mkw0ek++Qg+usVPjI2u
	0Uq9i+VaLDEsXSdnQLp3Aux9UDIS06LxnffyCWj01/Gaz8ezVkyInAF4M9uztLQobyP3+J
	iARA3pVY/KBOqfwPeTxmKI5GKVXYGs5AJCj2wY+H+EwVoQhW6iP5G03FQ2QjGw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1702062465; a=rsa-sha256;
	cv=none;
	b=bYEe2nb+uwsRywomyJ12+wLiJ0aVmr9lqT3JBkvXxYplV+4IKgeCcqM/Ew6YXnOJqyjT8Q
	Ajp1E6K6EZJEE14fpijoE7yi6SPR99lgEReNPYn0Dx8IBYwHXh3lY9TWy17WPvIJQMpGiD
	6G4NYF21d1a0UEO4ejzB6o4cV9bGbiJwDQlvU2cej/6bF8VsVrhxmXKrTE7LJGRMC5PsOq
	Ol3sJ1zWR0X7n+MJ0m5WXDKHoo8Txx+PzwtAdLA4V/WEFHl3tly8rnlteO5yBJBA/PZasx
	Axy1J6FjGy5qWbizb6Z/TnYDko0hi/UN7OXqnWbQuLVIi4mpLEIn+5fBd9tVeQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702062465; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GGVDlKYmDU/1tbkuJjfbk6JvWhTSx4mOggBnQC67DWs=;
	b=E5Lv4xvOv5W20rzc/mPOlwMf8+hSiR1ROiF4C7kUI7yuRu3bsLkyeQHQxBSedaikbdGTQa
	FlfWqQNyz7iAB7oboncr4Lls0f4ZOSZcVT4WbUhGtS0gFWq/ipqV5YsJQS/hEsUS8dzbT5
	A+IhFOKSxpMObMfloaa5RpLRZ4X/54F+ig2hnOvxTPDRosTOnWcaDhPvQ5RwMtZHJNQLzQ
	GyowM81/ryuS64WOs9rd9G+UQGQHXgwjEibs+oj5XsDQdNPO8xWhuHH9ttYXqK0SwNSl3b
	ln7CasC6yfHifUuV+puwQHtM718CvLvt6w4bTwDtYzzk5iMiXLmmo7kgc6B13Q==
From: Paulo Alcantara <pc@manguebit.com>
To: Tom Talpey <tom@talpey.com>, Steve French <smfrench@gmail.com>,
 samba-technical <samba-technical@lists.samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, Shyam Prasad N
 <nspmangalore@gmail.com>, meetakshisetiyaoss@gmail.com, Meetakshi Setiya
 <msetiya@microsoft.com>
Subject: Re: Lease keys and hardlinked files
In-Reply-To: <2f21c53c-c374-40d3-b9ff-f2af8ec219cb@talpey.com>
References: <CAH2r5mtK-JQeH5gLoGjUS5sywfd-KTJhnF_Mf4c+KCoapMEPhQ@mail.gmail.com>
 <2f21c53c-c374-40d3-b9ff-f2af8ec219cb@talpey.com>
Date: Fri, 08 Dec 2023 16:07:41 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Tom Talpey <tom@talpey.com> writes:

> On 12/8/2023 12:01 PM, Steve French wrote:
>> Following up on a question about hardlinks and caching data remotely,
>> I tried a simple experiment:
>> 
>> 1) ln /mnt/hardlink1 /mnt/hardlink2
>>     then
>> 2) echo "some data" >> /mnt/hardlink1
>>     then
>> 3) echo "more stuff" >> /mnt/hardlink2
>> 
>> I see the second open (ie the one to hardlink2) fail with
>> STATUS_INVALID_PARAMETER, presumably due to the lease key being reused
>> for the second open (for hardlink2) came from the first open (of
>
> Ok, so that is a client bug.

I guess Steve forgot to mention that the above only happens with the
patch applied.
