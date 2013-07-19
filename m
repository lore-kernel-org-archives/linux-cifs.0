From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Correct max string lengths
Date: Fri, 19 Jul 2013 16:52:16 -0500
Message-ID: <CAH2r5mtfSZCOaYieXQLEWhKEg8tQ7vgbtT=oM2oKvKtr=K9Ecg@mail.gmail.com>
References: <1374269172-4964-1-git-send-email-scott.lovenberg@gmail.com>
	<CAH2r5msAt8ZuXYdNzufB3BOah7f2ywyi3EgbS14ahESWe1BMRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msAt8ZuXYdNzufB3BOah7f2ywyi3EgbS14ahESWe1BMRw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

To Samba server - note very long share name (other servers also support this)

steven@steven-GA-970A-DS3:~$ smbclient -L //localhost
Enter steven's password:
Domain=[WORKGROUP] OS=[Unix] Server=[Samba 4.1.0pre1-GIT-e3f5e47]

	Sharename       Type      Comment
	---------       ----      -------
	BREALLYLONGSHARENAME0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Disk      Long name test Directories

On Fri, Jul 19, 2013 at 4:51 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> MAX_SHARE_NAME of 80 is not correct.  I verified that Samba supports
> much longer (see below), but also found some hits on other servers
> with longer limits when searching for this.   Windows CLI does appear
> to limit to 80 only in the NET SHARE command (also note that maximum
> UNC path is probably limited by MAX_PATH to 32768 characters)
>
> On Fri, Jul 19, 2013 at 4:26 PM,  <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> The max size of the username, domain, password and share name strings
>> are now consistent with the kernel and Microsoft's documentation.
>>
>> Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  AUTHORS      |  2 ++
>>  mount.cifs.c | 27 ++++++++++++++++++---------
>>  2 files changed, 20 insertions(+), 9 deletions(-)
>>
>> diff --git a/AUTHORS b/AUTHORS
>> index 2807079..2f6a14d 100644
>> --- a/AUTHORS
>> +++ b/AUTHORS
>> @@ -5,5 +5,7 @@ Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>  Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>>  Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>>  Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> +Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> +
>>
>>  ...and others.
>> diff --git a/mount.cifs.c b/mount.cifs.c
>> index 3b2b89e..8d975b3 100644
>> --- a/mount.cifs.c
>> +++ b/mount.cifs.c
>> @@ -83,22 +83,31 @@
>>  /* max length of mtab options */
>>  #define MTAB_OPTIONS_LEN 220
>>
>> -/*
>> - * Maximum length of "share" portion of a UNC. I have no idea if this is at
>> - * all valid. According to MSDN, the typical max length of any component is
>> - * 255, so use that here.
>> +/*
>> + * Max share name, username, password and domain sizes match the kernel's
>> + * allowances for these string sizes which in turn match Microsoft's
>> + * documentation.
>>   */
>> -#define MAX_SHARE_LEN 256
>>
>> -/* max length of username (somewhat made up here) */
>> -#define MAX_USERNAME_SIZE 32
>> +/* Max length of the share name portion of a UNC.  According to Microsoft
>> + * this is correct for Windows 2000/XP. */
>> +#define MAX_SHARE_LEN 80
>> +
>> +/* Max user name length. */
>> +#define MAX_USERNAME_SIZE 256
>> +
>> +/* Max domain size. */
>> +#define MAX_DOMAIN_SIZE 256
>> +
>> +/* Max password size. */
>> +#define MOUNT_PASSWD_SIZE 512
>> +
>> +
>>
>>  #ifndef SAFE_FREE
>>  #define SAFE_FREE(x) do { if ((x) != NULL) {free(x); x = NULL; } } while (0)
>>  #endif
>>
>> -#define MOUNT_PASSWD_SIZE 128
>> -#define MAX_DOMAIN_SIZE 64
>>
>>  /*
>>   * mount.cifs has been the subject of many "security" bugs that have arisen
>> --
>> 1.8.1.4
>>
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
