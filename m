Received: from manage.vyzra.com (unknown [104.128.60.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78092331A48
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 13:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.128.60.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760706308; cv=none; b=mSNM1SwfKkcJwtuFtoDHoPItX54724LGPi9xLc1YP9xV5ALS3y5wzjfqocS9p6OPgE4y+wz1DEEWvvoRaNOhU66x/rRmAmTpLv1397jNr/OM9YdCGGWNVXOHsqQShSBwTxv2sC/Obbllmu3Q58CjQiv3BycOa82OdyYfdMejKjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760706308; c=relaxed/simple;
	bh=biLnUx9jTTyVdIbdiavoTAgEZeIqqOihfb373MH/e18=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uKeGwpSZs1RMH2nAZt03au0ccH/w6AKM374z2Wzd8+gya1T89cT2iLxpJAuXOkP5M62ME3d7D9eQb56+TT1Wi7pJkhqD+keS3f/BcGkv60d4zHEsxRUu/UmUp9rT2yZgxZKkVvqJuTDcqj2YFxzGj6UQu7kINzSFo2nQ6U25zcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debtmanager.org; spf=none smtp.mailfrom=manage.vyzra.com; dkim=fail (0-bit key) header.d=debtmanager.org header.i=@debtmanager.org header.b=dRNZbPUf reason="key not found in DNS"; arc=none smtp.client-ip=104.128.60.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debtmanager.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=manage.vyzra.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=debtmanager.org header.i=@debtmanager.org header.b="dRNZbPUf"
Received: from debtmanager.org (unknown [103.237.86.103])
	by manage.vyzra.com (Postfix) with ESMTPA id 2D9E048FFD8A
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 07:45:31 -0500 (CDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=debtmanager.org;
	s=DKIM2021; t=1760705132; h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
	bh=Aj8bDacQlJB5qNMC5+yWWged1+K/M8YReXQkzUminbQ=;
	b=dRNZbPUfe55EZXMnB/syPTSKlukEpHrOMcUL93tqQ3uTPxXo4bFvPPST+222q8rJLL5wIj
	RINODVSVP3PT0F/44Ucu/G9VmsEu7bUz3R9x9d+1/c/dJb8JF5ORDSLmrGGFn0+VdGIjjR
	ID9/JeEY03ZiQPPWU6oa+JCKuix5pjZwPZbKoBxg0PIT19s/rLaOvwo9+nTEPwoYvguX0s
	nDubn7REL3ww+QOR/b/gC/h0SaT4jCtlRtEVb+yEDeo4a9RDQmNlAsL21y/VQjQhcBAKzN
	7T5DN8lxxEtlkwg8bBnhkHHpi3W5P8cqxCJaDbWGGgbsIrQO7k9MDqYvAqWEGw==
Reply-To: vlad.dinu@rdslink.ro
From: "Vlad Dinu" <info@debtmanager.org>
To: linux-cifs@vger.kernel.org
Subject: *** Urgent Change ***
Date: 17 Oct 2025 05:45:31 -0700
Message-ID: <20251017054531.F89B8E8C3D7E8661@debtmanager.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Score: -0.10

Hello,

I am Vlad Dinu, the newly appointed Director of IMF Legal=20
Affairs, Security and Investigation. I have been given the=20
responsibility to look into all the payments that are still=20
pending and owed to fund beneficiaries / scam victims worldwide.

This action was taken because there have been issues with some=20
banks not being able to send or release money to the correct=20
beneficiary accounts. We have found out that some directors in=20
different organizations are moving pending funds to their own=20
chosen accounts instead of where they should go.

During my investigation, I discovered that an account was=20
reported to redirect your funds to a bank in Sweden.
The details of that account are provided below. I would like you=20
to confirm if you are aware of this new information, as we are=20
now planning to send the payment to the account mentioned.

NAME OF BENEFICIARY: ERIK KASPERSSON
BANK NAME: SWEDBANK AB
ADDRESS: REPSLAGAREGATAN 23A, 582 22 LINK=C3=96PING, SWEDEN
SWIFT CODE: SWEDSESS
ACCOUNT NUMBER: 84806-31282205


A payment instruction has been issued by the Department of=20
Treasury for an immediate release of your payment to the bank=20
account above without further prejudice. We cannot approve or=20
schedule payment to the 

given bank account without your confirmation. May we proceed with=20
the transfer to the Beneficiary: Erik Kaspersson, bank account in=20
Sweden?

I await your urgent response.

Mr. Vlad Dinu.
