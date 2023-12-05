Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274AE17727
	for <linux-cifs@vger.kernel.org>; Tue,  5 Dec 2023 07:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OPSTIIjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D07DC433C7
	for <linux-cifs@vger.kernel.org>; Tue,  5 Dec 2023 07:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701762485;
	bh=C6D0tLjPt3YkY5YoBs7Uj9K/0s2gcRdGIebkQ7OcGk0=;
	h=From:Date:Subject:To:From;
	b=OPSTIIjMZBPWjKvzj4GdvujQTV+DbIq3NGRJmz9uMYTWbBJJFa+amr6/JlQtodOUG
	 +iZHQVkJIDMTe/EM+ztg5V5L/JPOQmEZqwuR0M4hZUljV1a4V61XcAKvoXpUWcQpvz
	 WC1gGZRlTibUynErpiHGIoYP4Ty0mAI628F/KTUpTIxWXjc9WT5CEj2p+yYmI+fcqC
	 kw4VBgJ98Ywxw+E2W4Ekkw+wlLaXRPJrWoBkT5pCXnQuDHL47mLfJmUud7qF6mUW8x
	 MVE2yjNEEAe/HwjC+o5catj8Bg94HKAXp+siXOKytVjh1iPyRkGQwhToRMQw0q5zXN
	 RXH8VMqPtNEpg==
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-1faf56466b8so2422712fac.3
        for <linux-cifs@vger.kernel.org>; Mon, 04 Dec 2023 23:48:05 -0800 (PST)
X-Gm-Message-State: AOJu0YwoZp0ImDa36p3rjXg6aScgc1KYNWSUPbjgkP38F2G2CEnzEnkv
	vT+GAkkZA0pXRhpbYbPc3kI+DarU7PhpPwVg9wI=
X-Google-Smtp-Source: AGHT+IGFvKbDumO/yFY9gPgUBCLeqsIvgmFpCai1pu68IuofO01ga+7en9K/PbtDESb/Y6ZHe2kxWKl7UPSNJJPn7Zo=
X-Received: by 2002:a05:6870:350f:b0:1fa:31c4:6fd9 with SMTP id
 k15-20020a056870350f00b001fa31c46fd9mr7730172oah.43.1701762484887; Mon, 04
 Dec 2023 23:48:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:ac9:5a85:0:b0:507:5de0:116e with HTTP; Mon, 4 Dec 2023
 23:48:03 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 5 Dec 2023 16:48:03 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9-61f1cjXMrovSEdio8fuTSbegfde4FZ9m1DAAS+CxRg@mail.gmail.com>
Message-ID: <CAKYAXd9-61f1cjXMrovSEdio8fuTSbegfde4FZ9m1DAAS+CxRg@mail.gmail.com>
Subject: Name string of SMB2_CREATE_ALLOCATION_SIZE is AlSi or AISi ?
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"

I found that name strings of SMB2_CREATE_ALLOCATION_SIZE are different
between samba and cifs/ksmbd like the following. In the MS-SMB2
specification, the name of SMB2_CREATE_ALLOCATION_SIZE is defined as
AISi.
Is it a typo in the specification or is samba defining it incorrectly?

samba-4.19.2/libcli/smb/smb2_constants.h :
#define SMB2_CREATE_TAG_ALSI "AlSi"

/fs/smb/common/smb2pdu.h :
#define SMB2_CREATE_ALLOCATION_SIZE             "AISi"

Thanks.
