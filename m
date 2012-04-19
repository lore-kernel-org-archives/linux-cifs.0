From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: fix up some -D_FORTIFY_SOURCE=2 warnings
Date: Thu, 19 Apr 2012 17:38:43 +0530
Message-ID: <4F90004B.1050600@suse.com>
References: <1334800211-870-1-git-send-email-jlayton@samba.org> <4F8F9C73.2060904@suse.com> <20120419071354.015d7400@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120419071354.015d7400-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 04/19/2012 04:43 PM, Jeff Layton wrote:
> On Thu, 19 Apr 2012 10:32:43 +0530
> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
> 
>> On 04/19/2012 07:20 AM, Jeff Layton wrote:
>>> ...and add -D_FORTIFY_SOURCE=2 to the default $CFLAGS.
>>>
>>> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>> ---
>>>  Makefile.am  |    2 +-
>>>  mount.cifs.c |   12 +++++++-----
>>>  mtab.c       |    4 +++-
>>>  3 files changed, 11 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/Makefile.am b/Makefile.am
>>> index d95142a..05729ca 100644
>>> --- a/Makefile.am
>>> +++ b/Makefile.am
>>> @@ -1,4 +1,4 @@
>>> -AM_CFLAGS = -Wall -Wextra -Werror
>>> +AM_CFLAGS = -Wall -Wextra -Werror -D_FORTIFY_SOURCE=2
>>
>> Seems a good thing to do given that the number of vulnerability reports
>> in the past.
>>
> 
> Most of the vulnerabilities have occurred when people install this as a
> setuid root program, and then exploit the behaviors that were designed

Yeah, most of them were exploitable when the program is setuid root.
Though some of the distros are shipping mount.cifs without setuid these
days, it is not hard for users to enable it implicitly.

> in from the beginning. We haven't had many (any?) vulnerabilities from
> straightforward bugs...

Don't remember exactly but I'm sure we didn't have any major ones atleast.

> Still, it certainly doesn't hurt...
> 
>>>  ACLOCAL_AMFLAGS = -I aclocal
>>>  
>>>  root_sbindir = $(ROOTSBINDIR)
>>> diff --git a/mount.cifs.c b/mount.cifs.c
>>> index f0b073e..ecbf034 100644
>>> --- a/mount.cifs.c
>>> +++ b/mount.cifs.c
>>> @@ -928,10 +928,10 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
>>>  				}
>>>  			} else {
>>>  				/* domain/username%password */
>>> -				const int max = MAX_DOMAIN_SIZE +
>>> -						MAX_USERNAME_SIZE +
>>> -						MOUNT_PASSWD_SIZE + 2;
>>> -				if (strnlen(value, max + 1) >= max + 1) {
>>> +				const size_t max = MAX_DOMAIN_SIZE +
>>> +						   MAX_USERNAME_SIZE +
>>> +						   MOUNT_PASSWD_SIZE + 2 + 1;
>>> +				if (strnlen(value, max) >= max) {
>>>  					fprintf(stderr, "username too long\n");
>>>  					return EX_USAGE;
>>>  				}
>>> @@ -1603,8 +1603,10 @@ add_mtab(char *devname, char *mountpoint, unsigned long flags, const char *fstyp
>>>  	mountent.mnt_passno = 0;
>>>  	rc = addmntent(pmntfile, &mountent);
>>>  	if (rc) {
>>> +		int ignore __attribute__((unused));
>>> +
>>>  		fprintf(stderr, "unable to add mount entry to mtab\n");
>>> -		ftruncate(fd, statbuf.st_size);
>>> +		ignore = ftruncate(fd, statbuf.st_size);
>>
>> Though this would mean a little extra code (esp. with -Werror), I think
>> it makes the code readable.
>>
> 
> That's necessary due to the "ignored retval" warning. We could also
> wrap it inside an "if() {}" block or something, but I think this is
> clearer and this isn't a terribly hot codepath anyway.
> 

Agreed, this looks cleaner.


Suresh
