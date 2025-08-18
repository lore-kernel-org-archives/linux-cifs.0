Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2DF1E51FB
	for <linux-cifs@vger.kernel.org>; Mon, 18 Aug 2025 20:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755549067; cv=none; b=EIl55oahpDMJ9zs1jHmg+dqkbCMxkLA/Ij/nuFrATPx45BEiaHWfV8XAvjmDpBuTIuipGWOKKBp4Pvqwf0kX2GPnjDymR8LFKzeDBKuEnQj6GOi0+cJIxv+hfWY7Py+CMETBWKtIp3c3uhdd0rEwcrGLVp42uo7evicfSIOxuqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755549067; c=relaxed/simple;
	bh=kyD+HXTbIvpjwuHe64kwXuqnkL+hjSXsRjC27dpPOnw=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=seJc9niKLEFOxuiMCIzk+riiWwqCgK+V27jTzy00k/hIrKZSNur80jxrc4P84QDoMjR5PWaW+9b3I8pgHaBNT1UYRiNXvD9f4dpSvDTfXQQhb7z/8sUs7LEoL6y5oBoewefLp2GlpSOc2CHncBe5L3WZVd+sAaEpmaMWZ6Wc+Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=U7Gomt6L; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="U7Gomt6L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=ANUkFkKuMUsNowCTgcYzlhuCPV23pdRt50KVF2MzwqM=; b=U7Gomt6LnJxAuAN+sm9hu3+vE/
	jLWX3ZqPZSoQavuQCPDu2HJyBVNnsae4k7SxYKHNmk+yHXtHy8oWRm8OiJfF0MK5TLIaVtUU7tIBv
	ez77XLS3DQ3jZbaTbblf/bYDTknfm3xyq1bEWxE6G5tH48pJB7cL5WDNIKEaaK2V42hvLkMgjR5A0
	OCD0rjG6ORVJGcJp2n+HxK0AroeTg/3IcSc7FHbqzTj/JDaV3HRyR4kzaWDkztrtk9OU7ie3IsgL/
	1y5aHftn+pJCH7kYoTgBhzox6C0oNlRb5Gjg5TGxfmAfRjrD4MRfYGJXAc6oO9pbVZ6sesJXe/Abe
	Ns1IbvXnAL8WtAWCRYtOKhV0XulP5UnVSwH6cPESozJ5RvfO6AMqgC+j7loi8txxMPORU2wD5ZWfd
	EntZqM7Xz6bFTesf+5qhJpROVkNgFUGZ2X0SZWMIYximXlK46DlaeOfW333+YqwhZ/MaN/YKb3fuA
	XnyL/Yiu5rbLdFgYnajyyPfn;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uo6VR-003Wor-26;
	Mon, 18 Aug 2025 20:31:01 +0000
Message-ID: <05881546-b505-4c0e-8d95-ee1c24f01fc8@samba.org>
Date: Mon, 18 Aug 2025 22:31:00 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 Samba Technical <samba-technical@lists.samba.org>
From: Stefan Metzmacher <metze@samba.org>
Subject: Common smbdirect debugging/loggin/tracing...
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

after the move to common smbdirect structures I'm wondering
what I have to keep related to the debug counters on the
client side, e.g.

         /* for debug purposes */
         unsigned int count_get_receive_buffer;
         unsigned int count_put_receive_buffer;
         unsigned int count_reassembly_queue;
         unsigned int count_enqueue_reassembly_queue;
         unsigned int count_dequeue_reassembly_queue;
         unsigned int count_send_empty;

And the their use (and more) in cifs_debug_data_proc_show().

I'd suggest to remove this stuff and later add some tracepoints
instead or if really needed some stuff under smbdirect_socket.statistics.

Also do we need to keep the log_rdma() based message in the client
and the ksmbd_debug(RDMA) messages on the server as is?
I guess we want some basic logging for the connect/disconnect handling
and the rest should be tracepoints...

Is something like logging module parameters and output
written in stone or can this be changed to be more useful
and in common between kernel client, kernel server and later
userspace?

metze
