From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] sync_smb2_mid_result
Date: Wed, 23 Mar 2011 13:02:51 -0500
Message-ID: <AANLkTikTYEtgQVhFpqop658tWsQ_=wQ3Be5FK27Uuxqk@mail.gmail.com>
References: <AANLkTinnLUXF3O=AOYG8PrCG1guAA8vkM18wYKSLegk2@mail.gmail.com>
	<20110323120617.0379e0a1@corrin.poochiereds.net>
	<AANLkTinVcBpT7X7A4XKd8+rz0XJw8ms159UnsK5aH49f@mail.gmail.com>
	<20110323135853.69b42c03@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110323135853.69b42c03-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Mar 23, 2011 at 12:58 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 23 Mar 2011 12:42:26 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Wed, Mar 23, 2011 at 11:06 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Sat, 12 Mar 2011 19:55:55 -0600
>> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> Previously CIFS added a function, sync_mid_result, to better handle
>> >> certain error conditions.
>> >> This patch adds the equivalent for SMB2 mids (they are used by smb2_sendrcv2
>> >> which is added in the next patch)
>>
>> > Now that you've commented out all of the unneeded fields from the
>> > struct smb2_mid_entry, it's clear that the smb2_mid_entry is a subset
>> > of mid_q_entry. Some of the mid_q_entry fields might need to be
>> > expanded (the mid number itself for example), but that hardly seems to
>> > warrant a completely new struct and codebase for this.
>> >
>> > Can you explain why we need all of this code duplication when it now
>> > seems fairly clear that much of the existing code could be repurposed
>> > for SMB2? This approach is going to vastly increase the maintenance
>> > burden and I don't see that we gain anything from it.
>>
>> Do you mean changing the cifs mid from its current single struct to a
>> nested mid_common which can be included in cifs and smb2 specific mids
>> (or made into a union)
>>
>
> No. I mean use the same struct for both, expanding fields in the "old"
> mid_q_entry struct as needed. For the "mid" field itself, for instance
> you could grow it to a u64 and just plan to not use the upper bits for
> smb1. Other fields could be handed similarly.
>
> A common struct here means that you can reuse more code.

We could make it a union presumably, but it means more
casts as the sizes of fields are different, and smb2 doesn't
need some of cifs fields, and smb2 will need at least 5
(but probably 10) more fields such as for "async response
received" and for chains of commands.  Overall that will
cause the size of the structure for cifs to grow at least
25% (probably more).


-- 
Thanks,

Steve
