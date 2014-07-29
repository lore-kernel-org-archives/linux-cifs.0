From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 00/16] SMB 2.1/3 multicredit requests for reading/writing
Date: Tue, 29 Jul 2014 10:19:12 +0400
Message-ID: <CAKywueRBDjsDVz_uR39xAGbp6VQD40erCvWGX5bWLpFOUJqYtw@mail.gmail.com>
References: <1405957558-18476-1-git-send-email-pshilovsky@samba.org>
	<53D6AF1E.4030804@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53D6AF1E.4030804-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-07-29 0:14 GMT+04:00 Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> Hi Pavel,
>
>> The goal of this patchset is to add large MTU/multicredits support for reading and writing from the CIFS client to servers > that support SMB 2.1 and higher versions of the protocol.
>
> Are looking at the returned capabilities from the server or just the
> dialect?
> The answer should really be the capability, it's wrong to rely on the
> dialect...
>
> metze

Hi Stefan,

The code of the patchset is looking at the returned
MaxReadSize/MaxWriteSize values from the server. If they are greater
than 64K, the module uses multicredit requests. Also it only works for
SMB 2.1 and higher versions and is disabled for SMB2.0.

The spec says (http://msdn.microsoft.com/en-us/library/cc246768.aspx):

"If the common dialect is SMB 2.1 or 3.x dialect family and the
underlying connection is either TCP port 445 or RDMA,
Connection.SupportsMultiCreditMUST be set to TRUE; otherwise, it MUST
be set to FALSE."

So, it seems like the server must should multicredit requests if
negotiating SMB 2.1 or 3.x protocols.

Anyway, if the server sets MaxRead(Write)Size value to more than 64K
and does not support multicredit requests, this server looks like a
broken one.

I can add a check for MTU capability bit for SMB 2.1 and 3.x protocols
before the check of MaxRead(Write)Size value and let the code fall
back to the 64K per request if this bit is missed.

Thoughts?

-- 
Best regards,
Pavel Shilovsky.
