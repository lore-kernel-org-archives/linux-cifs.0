Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F15212564
	for <linux-cifs@vger.kernel.org>; Sun, 30 Aug 2026 01:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788054054; cv=none; b=I8QLi3tmxDCVskYglYq++vU+GZm90JBBX6DFBf1h+idXkCxOuphNeiWzapYOcncF4qzt0uvcs+nWgYUTfE2FGDA6m+P1OAL3VytJyMjo673gLwGFomVjz62jnS1h2i9bSwM5xy3El/cJIWyzZPa1ZtHrwsfrupEjUTRKvl+m9w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788054054; c=relaxed/simple;
	bh=lO6GP6HC9WvVHRFWkLtr8n+CGp52FnMsNdIRxTOJyRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rTmhlpaV42yJFf5RGPspw7CfMw5gLlWS8RSmvJsdftGmISM9xCxRmwJ2padFnKeaKSzFeb2GtwmLVwnxdAp9eak2T1bQox2X1JqUfJddGH/77VjThk0Vuc5p3zVUhEVwAw1rb8HrBZCYW7PpfvOWmO9QgrZHyNWT1xgvBicdRnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ag8/aMKU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ag8/aMKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1DF1F000E9
	for <linux-cifs@vger.kernel.org>; Sun, 30 Aug 2026 01:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788054053;
	bh=lO6GP6HC9WvVHRFWkLtr8n+CGp52FnMsNdIRxTOJyRE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ag8/aMKURcZqYfEmPQvgY1RQ66ZAsj0v0JCMSGLKxVB7GAfULpRQhMdSTnHghtBaJ
	 e2VXmB6AV5GO9ffNOITdE1fUbnposN1ycjd4bfJhZJyDGxQh0crsUK1Q//yRWHWoSR
	 gLpULcrbR6JHtqk75PNytPNrfV+cJbjcrYm7egiBx46d9N84Rk8Hd+8C03GokY7J0h
	 crPjj5Kpk8YjKBnTGDPhIBU23sXkoOmuFPJDF/552VJ2gITj66cTYW7sizXZDMFGW9
	 2K1DSd0yXSQof0XuyTddFoZijYIFQurY1jcxUkyAXcnzapfM4grOAMAfBMqo3fS4Kd
	 lfvJh+mDMrMuw==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a0a4aa99bdso2878455a12.1
        for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 18:40:52 -0700 (PDT)
X-Gm-Message-State: AFuF++mfaan8sv5GzRD3ETE2pE2bMNOGQo3o+iv+MyOh7Hby6AthbIDo
	rWEIcatmUxZ627sLJaLEluqKzz7/Cnvz+VETjfAO9SItcCOTQzk+IHuXHJkn07kHeAJBHZYogs1
	kVtINFsOhk5b0egwlzSw80D8lOjo7JTw=
X-Received: by 2002:a05:6402:52c9:b0:6a6:32fd:ea2a with SMTP id
 4fb4d7f45d1cf-6a632fdec13mr2651959a12.22.1788054051734; Sat, 29 Aug 2026
 18:40:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826153147.4112943-1-sorenson@redhat.com>
In-Reply-To: <20260826153147.4112943-1-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 30 Aug 2026 10:40:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-tfWV+-sm9Sq_MMS_PToRBhS=sAppou4NQ7kgcvDMiHg@mail.gmail.com>
X-Gm-Features: AcwNN1VBXdWXAuo0WmrySlHdInZgeqZtDi9q5BWmAPayoQXm9-UeG8rEJRBhrbI
Message-ID: <CAKYAXd-tfWV+-sm9Sq_MMS_PToRBhS=sAppou4NQ7kgcvDMiHg@mail.gmail.com>
Subject: Re: [PATCH v3 00/11] smb: client: fix OOB reads and UAFs in SMB2/3
 receive paths
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 12:32=E2=80=AFAM Frank Sorenson <sorenson@redhat.co=
m> wrote:
>
> This series fixes eleven bounds-checking defects in the SMB2/3 client,
> all reachable from a malicious or compromised server.
Looks good to me except for two patches(leave the comments), but do
you have any test results? Incorrectly applying validation patches can
lead to critical issues that do not work normal operation. It would be
helpful if you included test results with xfstests or Windows clients
in the cover letter.
