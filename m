Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249601853
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 19:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754509694; cv=none; b=Pf5dLBCuAeJDJQmjZEXyB2d/xux2RmR0JtczueKZTn1q6sXF+mb9xuxfis06yNBM0OYR5/hx2USjPvinXQbvqgXTiniRKrkdkHgiilPm5hbzQo6GzZmdxxmHzD3RCSFzx5hp/PfBS/gVgcfzmcNTpMIPR+aj/F+Golu7rEcSSHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754509694; c=relaxed/simple;
	bh=9s++jHODxsY82WzSJ6MEVKP0FQ9WeMLcUquDgWoLC7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AO5LQOOO6TllwJRXjvgh3/r04aHoJ8LnFMow4O46FApX2kJcizOOLe8l++Ch1hZp4MW46FbkssCTneDyD7GLVWaZ5kX3PRlQGtRb56SvChLCNdQf6VJRPu2/jyYloydFqjfog5jx5WHeysAttHWViEIlHy9lM9lcCNB6hFbbWTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EJqTeupJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EJqTeupJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754509692;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oJoY2ALrE1hZvkzX549t70DSS4K2qQdrq1jiKR8aUDI=;
	b=EJqTeupJmTIpSORCmYjfsvOd9TV7T/IttDwjSpXj9tr10jrej4V07wQuw55hFkalI1kBUD
	/91cf5hVnQXOaj0LevzAyXRbNL1d6M0xtflaYxWjQ6da4aQ8la1saRjsbAJWza19sp6IBK
	VnWJZx8oDdJ5tmId2aO9HRJdCYTarMo=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208-biSuob5RObKPkZmqGqd6hw-1; Wed, 06 Aug 2025 15:48:10 -0400
X-MC-Unique: biSuob5RObKPkZmqGqd6hw-1
X-Mimecast-MFC-AGG-ID: biSuob5RObKPkZmqGqd6hw_1754509690
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4b08898f776so5774931cf.1
        for <linux-cifs@vger.kernel.org>; Wed, 06 Aug 2025 12:48:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754509690; x=1755114490;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oJoY2ALrE1hZvkzX549t70DSS4K2qQdrq1jiKR8aUDI=;
        b=HlaWOlbp4aKmt2UMslpOPwjSsZ0CdT0R1yK+1PRPmdXYUDmLChiKTYSe0CJjh/zQ0Q
         aHCoUspMrhIp2tnG0ug5wkdxzM0rHs310xrhGx98qE0TK9PK6y90Z7fSaBVQl/OiKhAN
         4db+bvCXb+uUyjsnU8k9AyidLzMpVP2vJaDm2AEI2uzqoEZurkpt23XGYDmlFTXE+sCT
         khr2guvtncz5Y2J6TOMveZ8Hfa3jFE72infIPqjnyjsuX75z2RODs3aEu7ScJw0Mq2m9
         j7oW+RAAIHtuUHrK5Tq5xDH6JR0d1qvyD7stskKBMRFAzH+s8g+UB3F7z5717/VLoodH
         CSSA==
X-Forwarded-Encrypted: i=1; AJvYcCWsKRMFek3RWhiYYSXOUjKdbB/6Rv107hSzVlY/aqPK36rmGo8TLwUENokIqT6Wza7pRREsZ5U9X1BV@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5wBnJLIw7gzQaEuNz1+HC07s9745blKciR6J+EdOAlvFzoxqR
	6eIACV58bBxPNhzLYgIYZES4y547BRykjrt28WVD8F0GqgWTPpC55Ij7uGjEwlk/p/l5ktRp3kE
	azBGrX8SBceOBoVcd570xehlIB1kdQOUEtMjtfUg01ckmkKO+CLEXBGvdICsQMyJNl7Ur+8E=
X-Gm-Gg: ASbGnctXQM5TY5cuC7a/7OFV3S8QIE09/Y6stdG2VW4d6D095z1j9YzieL7udcVuKNU
	+Gw8Gqy9wPFBJm4U7LmsORud8c0BYEq5Mn97Mw0rqKpIhgaWEAZmgilHgNaVIIQAD9aOCO08mk4
	23ZodRZV3UU34p7ra+EuhZPBuV3nczQS6otJ40Rh8aepkgCI5Y2N/sHtuFX4Mmyr/nHFUfsjgOp
	Lj85LPJTmLwljlCNFAPPbTONlO5R5XqpopmdMJfEoUSRV/JwYwigvd7uIAvh4BcviDjOJmgj61C
	zvpSdTIGiw/+1BXtmVO8Au9D0TDp3KvFqxxGzdPorNbAiv4INY5dMpjplnDTplfcaqmhQ6rquXN
	WZ0M=
X-Received: by 2002:ac8:5d14:0:b0:4af:1712:acc9 with SMTP id d75a77b69052e-4b091543ba8mr66779911cf.38.1754509689824;
        Wed, 06 Aug 2025 12:48:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrVt5Vk6hgzc4Pa+uKUPbdcMjN6lS6JxadUrOrIoudchKvUWdFGlTcEk1I7hHrX7CQximiQA==
X-Received: by 2002:ac8:5d14:0:b0:4af:1712:acc9 with SMTP id d75a77b69052e-4b091543ba8mr66779441cf.38.1754509689357;
        Wed, 06 Aug 2025 12:48:09 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b095e6c7d4sm10300101cf.54.2025.08.06.12.48.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 12:48:08 -0700 (PDT)
Message-ID: <4f20c584-aa44-4c8f-a3bd-6a7d72abf5e2@redhat.com>
Date: Wed, 6 Aug 2025 14:48:04 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [Samba] Sequence of actions resulting in data loss
To: Ralph Boehme <slow@samba.org>, Jean-Baptiste Denis <jbdenis@pasteur.fr>,
 Steve French <smfrench@gmail.com>
Cc: "samba@lists.samba.org" <samba@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
References: <16aeb380-30d4-4551-9134-4e7d1dc833c0@pasteur.fr>
 <a70fe80e-5563-467a-8c1f-9fd635662be4@samba.org>
 <fac383c2-2835-448c-a3fc-561f8aec02fa@pasteur.fr>
 <dd2f2bf1-f68d-496d-bca6-3f68672952aa@pasteur.fr>
 <6309360d-088e-49c1-b2db-9ef3169a32d4@pasteur.fr>
 <39705f0a-eb2d-42a1-a135-8751c8c851b0@samba.org>
 <86ae837a-3d30-4450-b91c-3186098178ca@pasteur.fr>
 <20250801121517.32376ad4@devstation.samdom.example.com>
 <62884dd9-0667-4111-afe6-f22ea7468d8e@pasteur.fr>
 <2d2289d7-f536-462f-9505-0ba700ad40b7@samba.org>
 <20250801134029.28a4d9a9@devstation.samdom.example.com>
 <fa99ce33-4eb7-4928-bdb8-8ff162f79856@pasteur.fr>
 <50971413-289b-46af-8f74-b77ca7e94d22@samba.org>
 <d6ff088e-21b1-4cae-bb9f-289f37979f02@pasteur.fr>
 <165cbcb9-f93d-481d-b974-17349311d1ea@samba.org>
From: Frank Sorenson <sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <165cbcb9-f93d-481d-b974-17349311d1ea@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 8/1/25 11:26 AM, Ralph Boehme wrote:
> On 8/1/25 5:16 PM, Jean-Baptiste Denis wrote:
>> On 8/1/25 5:10 PM, Ralph Boehme wrote:
>>> so it seems to be something in the cifs kernel client doing this. 
>>> Can you somewhere
>>  > post a network trace that covers this?
>>
>> Here it is:
>>
>> https://dl.pasteur.fr/fop/aAxGNfJR/file_delete_reproducer_c.pcap
>
> yeah, it seems to be the cifs kernel client.
>
> @Steve: is that really what you want to do in this case? Just delete 
> the rename destination? The application didn't request this...
>
> -slow


If I understand correctly, SMB has no atomic operation to replace/overwrite a file
through a SetInfo FILE_INFO/SMB2_FILE_RENAME_INFO operation, so it's accomplished by
the two-step process of 1) removing the target file; and 2) renaming the source
filename to the target filename.

However, while a file is held open, SMB prevents immediate deletion of the file, and
instead sets a 'Delete on Close' flag; the file is later deleted when all open files
have been closed.

With this reproducer, executing 'bash X.sh' opens the file, and keeps it open until
the script exits; since 'X.sh' sleeps 5 seconds, the file is still open when 'reproducer2'
executes 'mv' one second later.

Here, the client fails to simply rename the file, since it still exists:

59    1.163170722    Create Request File: x;SetInfo Request FILE_INFO/SMB2_FILE_RENAME_INFO NewName:X.sh;Close Request
63    1.166060791    Create Response File: x;SetInfo Response, Error: STATUS_ACCESS_DENIED;Close Response
65    1.166444945    Create Request File: x;SetInfo Request FILE_INFO/SMB2_FILE_RENAME_INFO NewName:X.sh;Close Request
66    1.168169687    Create Response File: x;SetInfo Response, Error: STATUS_ACCESS_DENIED;Close Response
67    1.168425699    Create Request File: x;SetInfo Request FILE_INFO/SMB2_FILE_RENAME_INFO NewName:X.sh;Close Request
68    1.170065571    Create Response File: x;SetInfo Response, Error: STATUS_ACCESS_DENIED;Close Response
69    1.170309883    Create Request File: x;SetInfo Request FILE_INFO/SMB2_FILE_RENAME_INFO NewName:X.sh;Close Request
70    1.171888290    Create Response File: x;SetInfo Response, Error: STATUS_ACCESS_DENIED;Close Response

so the client has to fall back to the Remove+Rename sequence:

the Remove:
71    1.172324565    Create Request File: X.sh;Close Request
     Create Request (0x05)
         Create Options: 0x00201000
             .... .... .... .... ...1 .... .... .... = Delete On Close: The file should be deleted when it is closed
72    1.174431365    Create Response File: X.sh;Close Response

the Rename:
73      1.174738312     Create Request File: x;SetInfo Request FILE_INFO/SMB2_FILE_RENAME_INFO NewName:X.sh;Close Request
74      1.176391700     Create Response File: x;SetInfo Response, Error: STATUS_DELETE_PENDING;Close Response

So the client succeeded in setting the 'Delete on Close' flag to remove the file, but
another process still has the file open, so the file was not actually removed yet.

Four-ish seconds later, 'sleep 5' completes, 'X.sh' exits, the client closes the file:
79      5.118570743     Close Request File: X.sh
80      5.119961726     Close Response

and the file is finally deleted on the server.

'reproducer2.sh' then wakes, and executes 'cat X.sh', which now fails due to the file
removal actually completing:

88      5.130503738     Create Request File: X.sh
89      5.131341391     Create Response, Error: STATUS_OBJECT_NAME_NOT_FOUND

Unfortunately, the end result is that the 'mv' fails, the target is removed, and the
source file still exists with its original name.

With the SMB semantics, I don't think there's a way around this condition.  "Rename &
overwrite existing target name" isn't atomic, there's no equivalent to the nfs
'silly-rename' of the target filename, and there's no "Oh, nevermind, unset that
'Delete on Close' flag" to backtrack the removal (and if there was, we couldn't
guarantee that we're unsetting the flag that only *we* set).

Frank

-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

