From: "Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Build infrastructure for storing NTLM creds in kernel keyring
Date: Thu, 5 Aug 2010 19:43:57 +0400
Message-ID: <9EE2EFBFF2304A849754EEE0F1C1CE29@lan.jax.org.ru>
References: <CC75E34383A8445493DD41AF4F7E7857@lan.jax.org.ru><20100721100503.672a735e@tlielax.poochiereds.net><9DFCDE0105DF4B70AEA82A8A2B2A2A94@lan.jax.org.ru><20100722093121.4c64b102@barsoom.rdu.redhat.com><54DA210795E649C1A62B5E10BF366BB3@lan.jax.org.ru> <20100804073140.5734d1bb@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> First, it looks like there are some problems with newlines. The new
> files that were added seem to have CR+LF line terminators. There are
> also quite a few whitespace problems in there -- spaces leading tabs,
> etc. In general, we follow kernel coding style with cifs-utils, so
> running your patches through checkpatch.pl in the kernel sources is a
> good idea.

Checked and patched.

> Also, I don't see much need for the MULTI_LANG ifdef's. Is there any
> reason not to make it always use MULTI_LANG? If so, I'd remove the code
> that's ifdef'ed out.

Now I am still not sure of the correctness of my strategy of 
internationalization. MULTI_LANG ifdef's will help me to correct necessary 
sites in case of its change.

> There are also several routines that seem to already be in libc. For
> instance, wstrtolower seems to do the same thing as towlower. I'd
> suggest using libc routines rather than rolling your own where possible.

As I saw in the GNU libc documentation there is no routines for conversion 
string to lowercase.

> That memcmp is going to walk off the end of "add". Depending on how the
> memory is allocated, it could segfault.

Patched.

> In cifscreds_add:
>
>                        if (keyctl(KEYCTL_SETPERM, key, KEY_POS_VIEW | 
> KEY_POS_WRITE | \
>                                   KEY_USR_VIEW | KEY_USR_WRITE) < 0)
>                                fprintf(stderr, "error: Setting permissons 
> on key\n");
>
> ...would it be safer to attempt to remove the key if we can't set perms
> on it?

Yes, already fixed.

> That's all I've got time to review at the moment. Have you made any
> progress with the kernel piece for this?

Yes, I have developed an algorithm and wrote some code samples.
This will require some changes in mount.cifs. The kernel will look for the 
key during parsing of pass= option in cifs_parse_mount_options routine. As 
an option pass= follows the options ip=, user= and dom= problems shouldn't 
arise. If successful, password will be used from the key, otherwise from the 
pass= option. mount.cifs can independently verify the presence of the key 
and does not require a password from the user.

Regards,
Igor Druzhinin

----- Original Message ----- 
From: "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: "Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sent: Wednesday, August 04, 2010 3:31 PM
Subject: Re: Build infrastructure for storing NTLM creds in kernel keyring


> On Thu, 29 Jul 2010 17:52:35 +0400
> "Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Hello,
>> I've created a mirror cifs-utils repository where is embedded cifscreds
>> utility. I've fixed a few bugs and added multilanguage support for it. 
>> Now
>> it is locale-dependent, but then I plan to use the UCS-2 encoding. You 
>> can
>> use the option --enable-cifscreds=yes of configure script to build
>> cifscreds. I've also moved resolve_host routine in a separate file and 
>> made
>> appropriate patches.
>>
>> git://gitorious.org/cifs-utils/cifs-utils.git
>>
>> Regards,
>> Igor Druzhinin
>>
>
> (cc'ing David Howells since he wrote most of the keyctl stuff and may be 
> interested)
>
> Sorry that it has taken me a while to review this, I've been a bit
> swamped with work.
>
> First, it looks like there are some problems with newlines. The new
> files that were added seem to have CR+LF line terminators. There are
> also quite a few whitespace problems in there -- spaces leading tabs,
> etc. In general, we follow kernel coding style with cifs-utils, so
> running your patches through checkpatch.pl in the kernel sources is a
> good idea.
>
> Also, I don't see much need for the MULTI_LANG ifdef's. Is there any
> reason not to make it always use MULTI_LANG? If so, I'd remove the code
> that's ifdef'ed out.
>
> There are also several routines that seem to already be in libc. For
> instance, wstrtolower seems to do the same thing as towlower. I'd
> suggest using libc routines rather than rolling your own where possible.
>
> On to the code...
>
> ----------------[snip]---------------
>        /* find the best fit command */
>        best = NULL;
>        n = strnlen(argv[1], MAX_COMMAND_SIZE);
>
>        for (cmd = commands; cmd->action; cmd++) {
>                if (memcmp(cmd->name, argv[1], n) != 0)
>                        continue;
> ----------------[snip]---------------
>
> This looks a little dangerous. Sure, you're bounds checking the
> strnlen, but think about what happens if someone passes in a long
> string as the command:
>
> memcmp("add", "reallylongcommandstring", 
> strlen("reallylongcommandstring"));
>
> That memcmp is going to walk off the end of "add". Depending on how the
> memory is allocated, it could segfault.
>
> In cifscreds_add:
>
>                        if (keyctl(KEYCTL_SETPERM, key, KEY_POS_VIEW | 
> KEY_POS_WRITE | \
>                                   KEY_USR_VIEW | KEY_USR_WRITE) < 0)
>                                fprintf(stderr, "error: Setting permissons 
> on key\n");
>
> ...would it be safer to attempt to remove the key if we can't set perms
> on it?
>
> That's all I've got time to review at the moment. Have you made any
> progress with the kernel piece for this?
>
> Nice work so far!
> -- 
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> 
