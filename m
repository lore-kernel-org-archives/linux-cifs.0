Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756FB30656
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 16:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Mv5W0san"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2921BFD
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 08:02:36 -0800 (PST)
Message-ID: <5deda9f23865fafcbd99d57424791138.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699459355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dk7dwy8NWfdLQyKcFnKlwrM/x1+oCmnez3djqBLF/5g=;
	b=Mv5W0sanXzg685E0pPdslTgo+dFkbTQ6aK4Z4r27QDYcqdopbrCRTbIz7hrW0n3F3cyA/o
	iBcNUp9g0SVKN3mU4kq43wKE7UElghovfNbp+vBKKOFtFDwf2Xif/lcvteVPXby8uo/Uvt
	VDq0rz5M4crDQuI1XuEGF9CNWvAA63YZdXO1opR9lmXLHI2mZwciv5WCf/MQ1f0rGePbmb
	3lA4zYGWo6H1/udHlsID8whayU5wru3ToltzXUTHoVSy4TEGIKgz1l2APkULQkhrWGNF/L
	wJW5QXF7n3SgEb5ClnsFN+EW8whBmZneV4SZ0BYvWgxkJKbVsLFhJ/nf2yt3XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699459355; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dk7dwy8NWfdLQyKcFnKlwrM/x1+oCmnez3djqBLF/5g=;
	b=AtPWmXmP2nlW1WlxYN3gkoEZHraLfLCRO2I5NRdgJx2dorfp9gyPI3FcJ5w2SJ2va4UFx3
	2R2lVVmlUpG16R6NN0v/3FkMvdhU2S44Ha9vTDyUqQvPiGv9kfHUg7D0xZN4062r05zXp8
	rlQI1Aj9sIPK8nz9B2d+F1rESG4kDVnHMESxCeQuXeg4dzb/wG7eMADumonY98ht4w4PEo
	E1pqjWdpPO5cwPiymXqnVIaoeJ0uaiB5zWysDC44zUE5nqh5t8cllrYboVk/uYrb70UFVq
	vAW6diDX5Rix3m/iHWxIQs0TAwmhL+PuQ1VTX+RS5UfnIKkda/g0IaS5HKyoFA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699459355; a=rsa-sha256;
	cv=none;
	b=dAaASI46L2briNY7ODu8UZIz8gd81rMUmZwTQCF6jetkPzfG2aVrPH7Hy8G/Y+6KuU+zlF
	ha5I27k02GiluA7HZiMVF2zorMdnSTndEUlZT3R5tJw11CokyObmZdYSRy3RxIPgyiqeJG
	YIKIBRLzA7DdYt5cfTxrNJGgaXURmNIlAAV4YTlKVV4I6Mvqr/sVJMuvCH3+o4PdqoayQj
	mBSVQM+yzvThLAjsyGblhLmWJwnhkDArgLQnNkmddtOznscF+agybAJqwQGRjft5JvPlvZ
	BUHSC+07fSFnhmcrOrY83mJa/Sct9J8+72PcH3sVVOkaEnkkEWKkpU/RQefLcA==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: nspmangalore@gmail.com, bharathsm.hsk@gmail.com,
 linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 11/14] cifs: handle when server starts supporting
 multichannel
In-Reply-To: <notmuch-sha1-c3bfa7f4ae0bb24c5ee7cfddb408c2fbeca5d8f7>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-11-sprasad@microsoft.com>
 <b709f32a96f04ff6136b69605788a2e6.pc@manguebit.com>
 <CAH2r5mtSZGJJYqFK1N+uT5gcr8vkUhLdYNE_VQ3nP67XxnnpPQ@mail.gmail.com>
Date: Wed, 08 Nov 2023 13:02:32 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.com> writes:

> Steve French <smfrench@gmail.com> writes:
>
>> removed cc:stable and changed
>>
>>> +                             cifs_dbg(VFS, "server %s supports multichannel now\n",
>>> +                                      ses->server->hostname);
>>
>> to`
>>
>> +                               cifs_server_dbg(VFS, "supports
>> multichannel now\n");
>
> Looks good, thanks.
>
>> Let me know if that is ok for you.  (See attached updated patch)
>
> For the s/cifs_dbg/cifs_server_dbg/ change, it is.

BTW, this patch in for-next branch still contains

        (1) misleading export of smb2_query_server_interfaces()

        (2) removal of mod_delayed_work() when reconnect failed

        (3) logging of failed network interface queries even when server
        doesn't support it.
