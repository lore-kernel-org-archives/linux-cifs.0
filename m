Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="SnmSuvKr"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6C7D44
	for <linux-cifs@vger.kernel.org>; Wed,  6 Dec 2023 06:08:19 -0800 (PST)
Message-ID: <e9921ba7ff3ec02cf5c0a0adc77d6edc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1701871697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M+s5KIbwFTaKcnF51Oh+i262wYsrmsq60wo4ZzG1XVk=;
	b=SnmSuvKrzem9yvleizHRwCuMgmqbMZFqPTq3E1LEUnSYqASkZ480lrLfFahoPP5k0l9kOG
	PhMQHIR0k0xUFIjlcFmcujBON5upeJxWahTKdSymDPGO02NOmAzTjocfgHx+9MKOXAsmps
	ryA3fpW1eLeOpW/0C8H7LOs4b2dy7IZ7SYmLKuFcWzCNkPr3IQtI7aQbaO2DcWPSOZ+bFv
	+n8hIfS7KviNdzW2hHwCK1UgH3MYYIIHtsl+cAPbh42vIqV1BaTXnjIj2iQtCqITj0zSuG
	kUmFeg1SBVCQh133dzR2R5j48n/WIuNYSh93KVaW0ggDPWVeUQYyRVvtEBFejw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1701871697; a=rsa-sha256;
	cv=none;
	b=RwM8UXBIfSh5vf0MIxNG3/k1ogOlt5bOTQ1nKXAbMrZSDwKP5ni1gPDPpNC+prbF0kzJji
	i4HNf3H3c17A10Kj2sXnbpXh0WtIxJS5+BjDJ0kPeqaP1Pe3RtFPbNBoDJ/DkAGW3Qmopc
	EFcpOFlWaknkUq0zy2aKEsupuTrTURM/9EhwNssCUzwVBYR75qeBTpKzugYMati9tTII2F
	O58S5Xcl3SSiOYE2eQVg1XwuD7vOjZFHSS5mevT/qul5YgkuSlwKTL5Fz8nAvWEr3eLEuZ
	7Ea+0eyez+u9JWwcPHLRrLajZxJzSw9DD4jnPOnF6HZWLMBk1G7lCtFuawrxVQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1701871697; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M+s5KIbwFTaKcnF51Oh+i262wYsrmsq60wo4ZzG1XVk=;
	b=SjDe3ESm3Bdt5cylwp6MG2cJqlH2ND6XDtirs+dolDfORCQCAxqreRRPEZxCF/ZPHDTgfw
	UiC/QtsvRHJ0c4T+DWxmkhuLUz9cAQ4N/Amevraw6FtndfEFW8MXMTXT97tdrtu62Zbvny
	jUl8fqEvDtquBUtT6yZCejhxJkAvVmyj2gPTGe2J0IgeW7OR2p8tnlRIDqeYsoJFsWbvsD
	ZxoucRxODOMZUM48IMhZ5d1GwcITm3vAv1gZMt/fDB4Z4kz9tT7cwX3znk03DmIHaozwmX
	745UE0vYDHa8G6egkmDXH8E7Yo4ZTOdibB+QdGcxb+1aQyck0tyE0u/9hYk0vA==
From: Paulo Alcantara <pc@manguebit.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: meetakshisetiyaoss@gmail.com, linux-cifs@vger.kernel.org,
 smfrench@gmail.com, bharathsm.hsk@gmail.com, lsahlber@redhat.com,
 tom@talpey.com, Meetakshi Setiya <msetiya@microsoft.com>
Subject: Re: [PATCH] cifs: Reuse file lease key in compound operations
In-Reply-To: <CANT5p=qnEFJDTTrSRkdBfkE9Kzw9BzGRegtCuW6Hb4xc7PSdaQ@mail.gmail.com>
References: <20231204045632.72226-1-meetakshisetiyaoss@gmail.com>
 <65d6d76197069e56b472bbfead425913@manguebit.com>
 <CANT5p=qnEFJDTTrSRkdBfkE9Kzw9BzGRegtCuW6Hb4xc7PSdaQ@mail.gmail.com>
Date: Wed, 06 Dec 2023 11:08:14 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Shyam Prasad N <nspmangalore@gmail.com> writes:

> That's interesting. I'm assuming that the STATUS_INVALID_PARAMETER is
> due to the server not recognizing the lease id for the file bar.
> I'm not sure that this is a client bug.
> If the server supports hard links, then should it not be aware that
> foo and bar are the same files? AFAIK, file lease is associated with a
> file, and not the dentry.

The patch is doing

	+	//if there is an existing lease, reuse it
	+	if (dentry) {
	+		inode = d_inode(dentry);
	+		cinode = CIFS_I(inode);
	+		if (cinode->lease_granted) {
	+			oplock = SMB2_OPLOCK_LEVEL_LEASE;
	+			memcpy(fid.lease_key, cinode->lease_key, SMB2_LEASE_KEY_SIZE);
	+		}
	+	}

and @inode ends up being the same for foo and bar from reproducer.  So,
the client is trying to close bar file by using lease key from foo.  The
server then fails to match @cinode->lease_key for bar file.
