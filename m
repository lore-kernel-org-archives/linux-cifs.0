Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2599480342;
	Mon, 14 Sep 2026 15:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789400117; cv=none; b=ssTKrLa+EvBFNhY+bl7rGCuab2C0UU32QfunpsspDLR8uXw3DwC11C6D8GcZCWCRnLSeHConqcMHXMIQpTcAjHCMb2tphr+ucCeXdveUkDSenK9s0r9H8L3z/3+HmoKBSj3lqlbrCKK37ALko8G8El0NdWGav1K56YMGQPWEDdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789400117; c=relaxed/simple;
	bh=QEwTrQOBdzKdxZGNZMMX8FKVxlRuYQfyokl0gvnP9cs=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=AiD5454kM92m4jVBxitnaAnX1VojZ6z+i2dIzTzIg8vUAL/L/POpKX5MBqgAvYDT8VhPao6pplJa2nimu67/qhc1zoZGvYoveuOvm+5Vzllo3yW4myV7xySoGmN3YAype+ohhjVJ8nf4oyqcxTZ0wx7j/DOQ3scbWjyrBoJqo3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=GvPcpyW7; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="GvPcpyW7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4J6QASSGNg3Ko0M2ZupQEjGTnNDRPX7fYEgsr98nOrE=; b=GvPcpyW7IKjfQ5Kp6/1v4UWP1f
	XmcJCtUiir+C6KVOA/XcDgavxWjwQjxu4q/jDCShra5GTeR9ri9aIKh9rnxv+y3negs99POmxPyBR
	lf7tK8zOrp0wI6njzNzyvrmRf/YMYanJ1ojIcwq4BsBSVWt36XvLC+S2AsJlp7Y+2bIPS9hMvZamj
	MgW7RurPTkhyfi1qIkNUXuWuATPFH6vcLfFYsnDUWARi5aO2FPqs1M63V4OxoZWRLJS5hM377+WyW
	uHtlI0UpdAqa9MD8SnK1TS/kzE5F/JO0fAlhGItjgrPTTRBWYvK0B+vhBeK7ljFYHy0ZgWIsWQ4xY
	RPQ1phdQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x68i8-00000001PA2-0s92;
	Mon, 14 Sep 2026 12:35:12 -0300
Message-ID: <cb00f905be2ff39e1fbb91d78686b1c4@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: David Howells <dhowells@redhat.com>, Christian Brauner <brauner@kernel.org>
Cc: dhowells@redhat.com, Frank Sorenson <sorenson@redhat.com>, Namjae Jeon
 <linkinjeon@kernel.org>, netfs@lists.linux.dev,
 linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfs: Fix netfs_read_gaps() to use separate sink folios
In-Reply-To: <3228134.1789399227@warthog.procyon.org.uk>
References: <3228134.1789399227@warthog.procyon.org.uk>
Date: Mon, 14 Sep 2026 12:35:11 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

David Howells <dhowells@redhat.com> writes:

>     
> Fix netfs_read_gaps() to use separate folios rather than re-using a single
> sink folio to discard the unwanted data so that cifs checksum checking sees
> all the data that was fetched.
>
> Fixes: 7f84a7b9892d ("netfs: Make netfs_read_folio() handle streaming-write pages")
> Reported-by: Frank Sorenson <sorenson@redhat.com>
> Closes: https://lore.kernel.org/r/a385053c-1c4a-4060-a3bb-befa007ddb33@redhat.com/
> Signed-off-by: David Howells <dhowells@redhat.com>
> Tested-by: Frank Sorenson <sorenson@redhat.com>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: Namjae Jeon <linkinjeon@kernel.org>
> cc: netfs@lists.linux.dev
> cc: linux-cifs@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org

Reviewed-by: Paulo Alcantara <pc@manguebit.org>
