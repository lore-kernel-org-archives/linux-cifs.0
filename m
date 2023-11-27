Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="RS93ybK5"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F86AD5B
	for <linux-cifs@vger.kernel.org>; Mon, 27 Nov 2023 02:14:30 -0800 (PST)
Message-ID: <9b17c94c65cbf7413b78dbea7a6ff5b9@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1701080066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vlZR0nqaTIE6bVJmVRtxjDTA9juWDabhTKATWhTQvSc=;
	b=RS93ybK51BF2iyB+4niXaxv74tfyOTGOaNmaIzHeQ94Mag/puvyRuBZoVdOWUl5HHelZVr
	+KgoH8E5gS67/FL4xeATtvYx1pJgjj9xNw+r+muOyYqkFPzJyw1HSngBiTaH27BcWQjWTu
	9LLDgkto7JtlIu2MhpGEMfZr/1ZHOkACLHELw23ZVdOy9+Ggv9WQdKFX6++pkKineHcG9Y
	QKEeUEfJg/27CtT0YGYfTVGBPyZ20uLIqjB1HVf6nKzB9rLgOPmDnxNFPKWNYYY4852bbC
	KgSy/zPRIWD8aVUmoFfEK9pI9hmguFW71b/hcqu1EIvMcpbh0KxuUhqeAY7D+Q==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1701080066; a=rsa-sha256;
	cv=none;
	b=qmi95sY3x8cY+2m+xJqv1eNbwq4roV+5KruN7iDCZfHb+qbsua4Fnu/ea96J0Wdoqbku9P
	gOVwT9huU/HgQI7HUfFebXrc8reSE8+RAISD+Z82qzM9LJy2oRF7SoQGK0Z980IeGUBklo
	eAq9re6K0QXp15C3pCm7wVAUInAVg49t1Up4jIksBsI5sfIWFNeMUNxguWewSt4NxHkqaB
	VyB7DoeLFxt9aKL3KuM5QC8Ws3YWMCqR/oe1BM+qoYHDuL9B+prvJlsO2gaazaa8pjFfA8
	+UbmWtdxttzuyRZbRupALVoERykHyWd2SEyDUTReSVrIvFl99YO2gyalasffEw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1701080066; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vlZR0nqaTIE6bVJmVRtxjDTA9juWDabhTKATWhTQvSc=;
	b=mFftVDI65otm2pHl9kIkc57Ft9d1uHPB6f361UGyxryGGpJLdubLuVnRl3Juc3oVM+kUZT
	cZdd0Gff142IUQjg0opzhni+l7U0FaQq5EGvLlJ+2rBgSRT7CZIQgQauofIbd5JZlupj5L
	vLAbbewlKanf5azhmZez7qYF20+wjgnaiyWHumKggA1jciN8jI2FvzJNy+aGQ30/lW68Ee
	jY9otP0UDiKPXVpik1crYg9rTqq7mGWkiRbKe1SJfI/Kz5o6e+uNdtwYaYpMQpIwDD+2Sr
	iUfYs5Vz7zPe9Elt7s6UDaBBT574dedhvB/t54C4KhNmCluJri2xMRut5PjbDA==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2 0/9] reparse points work
In-Reply-To: <CAH2r5mttTq-JhMVa7uMheJ8gmm9dJjMSCjhAWczuA5yUR4Tr2Q@mail.gmail.com>
References: <20231126025510.28147-1-pc@manguebit.com>
 <CAH2r5mttTq-JhMVa7uMheJ8gmm9dJjMSCjhAWczuA5yUR4Tr2Q@mail.gmail.com>
Date: Mon, 27 Nov 2023 07:14:23 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> tentatively merged to cifs-2.6.git for-next pending more testing and
> review

Please drop patch 8/9 as it is wrong.  We can't really do that as the
file could have been changed on server side to a regular file and
therefore the client would keep trying to open it as a reparse point.
That can be easily reproduced.

Yeah, that is the price we get when we don't have such information
directly from query dir responses.  Looking forward to having it with
the SMB3 POSIX spec :-)
