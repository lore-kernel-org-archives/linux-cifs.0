Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D1F18B460;
	Sat, 18 Jan 2025 12:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737202684; cv=none; b=Y7HvQFlcwatHSA2NdWAlaeNrnEr7+Hsfr+xHbxWq/BBf4gLBgmD5MvsUw7OYjsOjHMyEMsbUXv4Eh9WN+Y+IKdmoJaRE3oafMgQYhSaswgsOyGq0t5g+8V72s4pIfYMG7Y1p2YgzvbFQmxSC6kMqrtVNqeAr+h2y27QKafmb9SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737202684; c=relaxed/simple;
	bh=S6RXRIFXK9qY5EZGsfbvBp/Tqawi28fdCs5eAm+QEUw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gYSWwg4n7/B7NSwnVhbBETlyMp48LVHBGQTKTuo9q/VaaS49nj6llI7srNQNoP+SQcMI25BkJzThAq2klg3Vcjj2LT2OzOnSYGc2mT8N+cuPXF5t/2xudjhjtFbcCzqDu1IxqvkRb1ZCnI/4hFkI8oN7oEO8LvEFUnUs755fVzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=oQ+/6RpC; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="oQ+/6RpC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=pD9+k
	dC166Bhtxw7gPHGmMi+Zgd3tdd3V7M4MsGs9tI=; b=oQ+/6RpC23cweh58YsztR
	fgBa6ZLXWbSxAOSgiUNVklmpwfzc6CSRUfWKGXVho1BzEAe1g6vZJibfeLmRXsJs
	MgGhM1FwQqkLk5VrxSjU7ueZOwQMuyq2MHbGx0442Zao6J3jCn0dL0cqX5znPDWP
	E/6/i/yVNM6Zzb+amg39xs=
Received: from hello.company.local (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3XzvDm4tnqshTHA--.59913S2;
	Sat, 18 Jan 2025 20:17:08 +0800 (CST)
From: Liang Jie <buaajxlj@163.com>
To: tom@talpey.com
Cc: bharathsm@microsoft.com,
	buaajxlj@163.com,
	liangjie@lixiang.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	samba-technical@lists.samba.org,
	sfrench@samba.org,
	sprasad@microsoft.com
Subject: Re: [PATCH] smb: client: correctly handle ErrorContextData as a flexible array
Date: Sat, 18 Jan 2025 20:17:07 +0800
Message-Id: <20250118121707.3290124-1-buaajxlj@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <80f4901d-1261-4e74-b22e-a205928cf4ad@talpey.com>
References: <80f4901d-1261-4e74-b22e-a205928cf4ad@talpey.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3XzvDm4tnqshTHA--.59913S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZrWfCFW7CFy8tr4fXF47Arb_yoW5CFW3pF
	18Gas8Cr45J3W7Zw1qqay2vw15try0yFn5Kr45Xa4ruFyDGr1vkFn7trZI9ry0ka4kXa1r
	Kr4j9a4vvFZ0yFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUIksDUUUUU=
X-CM-SenderInfo: pexdtyx0omqiywtou0bp/xtbBzw-YIGeLmwQJnwAAsd

On Thu, 16 Jan 2025 13:02:51 -0500, Tom Talpey <tom@talpey.com> wrote:
> On 1/16/2025 2:29 AM, Liang Jie wrote:
> > From: Liang Jie <liangjie@lixiang.com>
> > 
> > The `smb2_symlink_err_rsp` structure was previously defined with
> > `ErrorContextData` as a single `__u8` byte. However, the `ErrorContextData`
> > field is intended to be a variable-length array based on `ErrorDataLength`.
> > This mismatch leads to incorrect pointer arithmetic and potential memory
> > access issues when processing error contexts.
> > 
> > Updates the `ErrorContextData` field to be a flexible array
> > (`__u8 ErrorContextData[]`). Additionally, it modifies the corresponding
> > casts in the `symlink_data()` function to properly handle the flexible
> > array, ensuring correct memory calculations and data handling.
> 
> Is there some reason you didn't also add the __counted_by_le attribute
> to reference the ErrorDataLength protocol field?
> 
> Tom.
> 

Hi Tom,

You're right; `__counted_by_le` would help to clearly associate `ErrorContextData`
with `ErrorDataLength`. It appears I overlooked this, and it should be added to
improve clarity. I will prepare an update [PATCH v2] to include the `__counted_by_le`
attribute.

Thanks for pointing it out.

Best regards,
Liang Jie

> > 
> > These changes improve the robustness of SMB2 symlink error processing.
> > 
> > Signed-off-by: Liang Jie <liangjie@lixiang.com>
> > ---
> >   fs/smb/client/smb2file.c | 4 ++--
> >   fs/smb/client/smb2pdu.h  | 2 +-
> >   2 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
> > index e836bc2193dd..9ec44eab8dbc 100644
> > --- a/fs/smb/client/smb2file.c
> > +++ b/fs/smb/client/smb2file.c
> > @@ -42,14 +42,14 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
> >   		end = (struct smb2_error_context_rsp *)((u8 *)err + iov->iov_len);
> >   		do {
> >   			if (le32_to_cpu(p->ErrorId) == SMB2_ERROR_ID_DEFAULT) {
> > -				sym = (struct smb2_symlink_err_rsp *)&p->ErrorContextData;
> > +				sym = (struct smb2_symlink_err_rsp *)p->ErrorContextData;
> >   				break;
> >   			}
> >   			cifs_dbg(FYI, "%s: skipping unhandled error context: 0x%x\n",
> >   				 __func__, le32_to_cpu(p->ErrorId));
> >   
> >   			len = ALIGN(le32_to_cpu(p->ErrorDataLength), 8);
> > -			p = (struct smb2_error_context_rsp *)((u8 *)&p->ErrorContextData + len);
> > +			p = (struct smb2_error_context_rsp *)(p->ErrorContextData + len);
> >   		} while (p < end);
> >   	} else if (le32_to_cpu(err->ByteCount) >= sizeof(*sym) &&
> >   		   iov->iov_len >= SMB2_SYMLINK_STRUCT_SIZE) {
> > diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> > index 076d9e83e1a0..ba2696352634 100644
> > --- a/fs/smb/client/smb2pdu.h
> > +++ b/fs/smb/client/smb2pdu.h
> > @@ -79,7 +79,7 @@ struct smb2_symlink_err_rsp {
> >   struct smb2_error_context_rsp {
> >   	__le32 ErrorDataLength;
> >   	__le32 ErrorId;
> > -	__u8  ErrorContextData; /* ErrorDataLength long array */
> > +	__u8  ErrorContextData[]; /* ErrorDataLength long array */
> >   } __packed;
> >   
> >   /* ErrorId values */

