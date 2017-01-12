From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SMB2: Enforce sec= mount option
Date: Wed, 11 Jan 2017 22:23:00 -0600
Message-ID: <CAH2r5ms0Yk-zxoh6+H+tNzSQTUxTd3t577V8R0gn0Xt7_ouk-Q@mail.gmail.com>
References: <1481179577-15995-1-git-send-email-sprabhu@redhat.com>
 <58756A3D.6000705@tlinx.org> <CAFB9KM3S+p3sU26LKGwqaZ_3g4gkPPzEFzohwAFOa-PZPqZTAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: L A Walsh <law-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>, linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM3S+p3sU26LKGwqaZ_3g4gkPPzEFzohwAFOa-PZPqZTAQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Some general thoughts:
1) users shouldn't have to know about the details of protocol
encapsulation, just security features that might matter to them
2) focus should be on SMB2.1 or later (SMB3 or later ideally), we can
leave cifs semantics alone.
3) warning messages are best printed in user space by mount.cifs
(since users don't often read kernel debug message logs)
4) there are few choices relevant for SMB2 and later
     a) krb5 vs. ntlmv2
     b) signing optional vs mandatory
              - and for SMB3.1.1 AES-CCM vs. AES-GCM (see
https://jira.corp.primarydata.com/browse/PD-22499)
5) sane defaults that make it easier for the user with the most common
case (SMB3 or later supported by server) are preferred

My preference would be:
   a) change smb2 and later behavior only (even limiting changes to
SMB3 or later is fine). No reason to change cifs and risk older
RHEL/SLES/Ubuntu users (and servers where support for LANMAN or NTLM
may have mattered)
   b) allowing multiple dialects and/or multiple "sec=" is fine, but
probably easier to limit changes to mount.cifs and this is pretty
simple if we only have two real choices today.
   c) changing default to allow no "sec=" to mean try ntlmv2 and krb5
(not sure which should be the default) is fine, but may be better to
do the retry in userspace
   d) allow SMB3.1.1 choice for CCM vs. GCM when we have support for
these in cifs.ko
   e) On invalid sec= choices for SMB2 and later e.g. "sec=lanman" or
"sec=ntlm" warn on these in userspace (in mount.cifs) - we can simply
strip them out before calling the kernel.
   f) "sec=ntlmv2" is fine to leave in since I don't see any harm in
treating ntlmv2 and ntlmv2 in ntlmssp and ntlmv2 in ntlmssp in gssapi
as synonyms for SMB2/SMB3 (the user shouldn't have to know how
encapsulation of passwords is done) - and if we ever would have to
retry in kernel to attempt the two encapsulation methods (ntlmv2 in
ntlmssp vs. ntlmv2 in ntlmssp in gssapi) that is fine.


On Wed, Jan 11, 2017 at 3:02 PM, Scott Lovenberg
<scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Jan 10, 2017 at 5:11 PM, L A Walsh <law-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org> wrote:
>> Sachin Prabhu wrote:
>>>
>>> If the security type specified using a mount option is not supported,
>>> the SMB2 session setup code changes the security type to RawNTLMSSP. We
>>> should instead fail the mount and return an error.
>>>
>>
>> ---
>> Saw the comment by Steve F, and it got me to thinking.
>> Please take this as a suggestion or idea...  I'm not
>> heavily committed to a single solution, at this point, as
>> haven't really thought through all of the ramifications.
>>
>> Is it possible to add a 'prefix' or 'suffix', like an
>> "=" sign or a '+' -- to mean:
>>
>> '=' = exactly this 'sec' level
>> '+' = this 'sec'-level or greater
>> '<' = less than or equal to this sec-level
>> ---
>> Using the symbols is a similar idea to some fields in
>> 'find' where +/- are used to indicate greater or less than
>> the stated number.
>>
>> I'm not sure about the symbols, exactly, but I know in samba I
>> ask for smb2 for the protocol and more often than not, only
>> get smb1, but I'd rather have it work than fail.
>>
>> Since I'm on a closed net, I'd have to say the same for
>> security options, but I'd like to have a choice to force it
>> if I wanted to...
>>
>> Anyway -- just an idea that might offer more flexibility than just
>> 'fail'...
>>
>
> It'd take a tiny bit of messing with the command line parser, but I'd
> be for that.  As a gesture of good faith, since I raised the issue,
> I'd be willing to submit the patch set for mount.cifs to support this
> if everyone is on board.  I'd suggest staying away from '<' and '>' as
> they're shell redirects though.  This would be a reasonable shorthand
> for a comma separated list (which also might take a bit of messing
> with the parser since we split on ',') - it could reasonably loop in
> the userland mount helper, mount.cifs, in much the same way Steve
> suggested that it should be handled in userland.




-- 
Thanks,

Steve
