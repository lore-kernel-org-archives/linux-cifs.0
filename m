From: Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: Interop Issue: SMB2+ async replies, and the kernel, Samba side
 fix enclosed.
Date: Sat, 27 Feb 2016 12:17:34 +0300
Message-ID: <CAKywueQ4BsnOs0s=wi6J6MOo9+xRK+i04NMUfjmM6j-fPHt8Ew@mail.gmail.com>
References: <CAAPGDwLnp90t7wiRb_tw-Md0jv-8w0Ye66jNcsRNioganVe2xg@mail.gmail.com>
 <CAKywueSMFrvreB8JMtwj8kt1BY1Yyq-Guy3Q3=wZFzuLCCOjZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: sfrench <sfrench@samba.org>, linux-cifs <linux-cifs@vger.kernel.org>,
 Samba Technical <samba-technical@lists.samba.org>
To: Ira Cooper <ira@wakeful.net>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAKywueSMFrvreB8JMtwj8kt1BY1Yyq-Guy3Q3=wZFzuLCCOjZA@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org

2016-02-27 12:11 GMT+03:00 Pavel Shilovsky <pshilovsky@samba.org>:

> 2016-02-23 15:55 GMT+03:00 Ira Cooper <ira@wakeful.net>:
>
>> If the server sends an interim response, then the real response, the real
>> response, is handled by standard_receive3() in the kernel, instead of the
>> proper function, and this causes a disconnect.  If there isn't a
>> disconnect, I believe the reply will just be discarded if I understand the
>> code correctly.  (That is a big if here ;) )
>>
>> I've written a patch for Samba to stop sending interim replies on
>> SMB2_READ
>> and SMB2_WRITE, when non-compounded to stop the impact of this issue.  We
>> may want to add SMB2_CREATE to the list of ops we don't send async replies
>> for non-compounded, but I'm not sold either way, I know we CAN go async
>> there!  I want some opinions here.
>>
>> This is not hidden behind a flag because compatibility issues that don't
>> impact protocol correctness usually aren't.
>>
>> Setting req->async_te = talloc_new(NULL); is just ugly, though it works.
>> If you have a cleaner approach, I welcome it.
>>
>> I request you please ASK me before pushing this one, yes, that means you
>> jra!
>>
>> For those interested in reproduction: I'd suggest using a server that's
>> rebuilt with a lower timeout set in smb2_read.c, though we've hit it with
>> vfs_glusterfs straight up, in our testing.
>>
>> Thanks,
>>
>> -Ira / ira@(samba.org|redhat.com|wakeful.net)
>>
>
>
> Thank you for catching this!
>
> It is the issue in the kernel client - a check for interim responses is
> missed for SMB2_READ command. I created a patch that should fix the problem.
>
> Could you please test it?
>
> --
> Best regards,
> Pavel Shilovsky
>
>
CC'ing @samba-technical from another email address (my original email was
rejected by the server).

>
