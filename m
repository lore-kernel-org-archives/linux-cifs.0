From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 30/45] CIFS: Enable signing in SMB2
Date: Mon, 8 Jul 2013 01:15:45 -0500
Message-ID: <CADT32eKGnyr=PaFxOuAMkMudTtnGGf9duo7xtE4d2mEGNC9U9g@mail.gmail.com>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
	<1342626541-29872-31-git-send-email-pshilovsky@samba.org>
	<k0vdnf$434$1@ger.gmane.org>
	<CADT32e+4DSN=CSCbL+8GoRePknpD3X0HSq1hjVsXf3KHXQcmTw@mail.gmail.com>
	<5034E29E.7030006@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5034E29E.7030006-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Any pointers would be really helpful and appreciated...

I am trying to make signing work correctly for smb2
with key exchange key and ntlmv2/ntlmssp with signing.

So as I see, for the first smb session on a tcp session, everything
works fine i.e. session setup and tree connect works.
But for the the second smb session on this tcp session, session setup
succeeds but tree connect fails i.e. signature is incorrect.

If the same second smb session happens to be the first smb session
on a tcp session session setup and tree connect succeeds i.e. signature
is correct but if the first smb session on this tcp session happens to be
the second smb session on this tcp session, session setup succeeds
but tree connect fails i.e. signature is incorrect.

Signature generating algorithm as in ms-smb2 3.1.4.1 is the same
all the time.
It is the session.sessionkey varies.

As I see from ms-nlmp, nonce is the session.session key (exportedsessionkey)
as in 3.1.5.1.2.  Since authentication always succeeds for these
ntlmv2 ntlmssp, encryptedrandomsessionkey must have been correct which means
keyexchangekey must be correct.
So not sure why for the second smb session on this tcp session,
session.sessionkey generates incorrect signature.


So in this case, my question is, if authentication/session_setup for
the second smb session succeeds, how can signing/tree_connect fail?

Regards,

Shirish

On Wed, Aug 22, 2012 at 8:46 AM, Stefan (metze) Metzmacher
<metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Hi Shirish,
>
>> On Tue, Aug 21, 2012 at 2:35 AM, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>>> Hi Pavel,
>>>
>>>> Use hmac-sha256 and rather than hmac-md5 that is used for CIFS/SMB.
>>>>
>>>> Signature field in SMB2 header is 16 bytes instead of 8 bytes.
>>>
>>> Sorry for the late reply, I just found a reference to this patch...
>>>
>>> To me it seems that this patch doesn't take care of the fact that
>>> the signing key in SMB2/3 belongs to the session and not to the transport
>>> connection.
>>
>> metze, where do you see that?  This is the signing key that is used to generate
>> signature, server->session_key.response.
>
> And 'server' is a per connection state not per session...
> which is ok for smb1 but not for smb2.
>
>>> Does the SMB2 code support multiuser mounts yet?
>>>
>>> Why are you using some "BSRSPYL " magic? I only saw that from Windows
>>> clients
>>> using SMB1. (Note: that servers just echo the signature from the
>>> request, if they don't do signing).
>>
>> IIRC, Jeff Layton added that code to encode BSRSPYL magic (string).
>> I could be wrong, it has been a while.
>> But, I do think this is a problem, signature in a smb message is not even
>> checked till key exchange handshake is session setup is done, right?
>
> A session setup response with STATUS_SUCCESS is the first signed message.
> Before that the server just echos what the client sends.
>
> For SMB1 windows client (and smbclient) send BSRSPYL if they would like to
> turn on signing later. But for SMB2 windows and samba send just zeros,
> which cifs.ko should also do.
>
> metze
>
