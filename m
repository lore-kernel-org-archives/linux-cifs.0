From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Strange hardlink behavior with CIFS
Date: Thu, 28 Oct 2010 16:38:28 +0530
Message-ID: <4CC959AC.10301@suse.de>
References: <1287428685.16450.282.camel@calx>	<4CBD6843.3060702@suse.de>	<1288200686.3764.55.camel@calx> <20101027163230.28591971@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101027163230.28591971-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/28/2010 02:02 AM, Jeff Layton wrote:
> On Wed, 27 Oct 2010 12:31:26 -0500
> Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org> wrote:
> 
>> On Tue, 2010-10-19 at 15:13 +0530, Suresh Jayaraman wrote:
>>> On 10/19/2010 12:34 AM, Matt Mackall wrote:
>>>> With Linux 2.6.32-35 and either Windows or Samba in nounix mode,
>>>> hardlink counts can mysteriously disappear:
>>>>
>>>> - create hardlink pair foo,bar
>>>> - stat foo -> nlink = 2
>>>> - open foo
>>>> - stat foo -> nlink = 1
>>>> - close
>>>> - wait or sync
>>>> - ls -l -> nlink = 2
>>>>
>>>> Original report is here:
>>>>
>>>> http://mercurial.selenic.com/bts/issue1866
>>>>
>>>
>>> A quick test on 2.6.36-rc4 kernel reveals that the problem is no longer
>>> reproducible. Could you try a more recent kernel and see whether the
>>> problem is reproducible?
>>
>> Test continues to fail with 2.6.36.
>>
>> # uname -a
>> Linux calx 2.6.36 #71 SMP Tue Oct 26 02:23:34 CDT 2010 x86_64 GNU/Linux
>> # mount -o nounix //localhost/stuff cifs
>>            ^^^^^^
>> # cd cifs
>> # touch foo
>> # ln foo bar
>> # ./h
>> file: foo nlinks 2
>> file: foo nlinks 1
>> file: foo nlinks 1
>>
>> # cat h.c
>> #include <sys/types.h>
>> #include <sys/stat.h>
>> #include <unistd.h>
>> #include <fcntl.h>
>> #include <stdio.h>
>>
>> #define FPATH "foo"
>>
>> int main(void)
>> {
>> 	int rc, fh;
>> 	struct stat st;
>>
>> 	rc = lstat(FPATH, &st);
>> 	printf("file: %s nlinks %d\n", FPATH, st.st_nlink);
>>
>> 	fh = open(FPATH, 0, O_RDONLY);
>>
>> 	rc = lstat(FPATH, &st);
>> 	printf("file: %s nlinks %d\n", FPATH, st.st_nlink);
>>
>> 	close(fh);
>>
>> 	rc = lstat(FPATH, &st);
>> 	printf("file: %s nlinks %d\n", FPATH, st.st_nlink);
>>
>> 	return 0;
>> }
>>
>>
>>
>>
> 
> Ok, I can reproduce this too. The problem is this nastiness in CIFSSMBOpen:
> 
>         if (rc) {
>                 cFYI(1, "Error in Open = %d", rc);
>         } else {
>                 *pOplock = pSMBr->OplockLevel; /* 1 byte no need to le_to_cpu */
>                 *netfid = pSMBr->Fid;   /* cifs fid stays in le */
>                 /* Let caller know file was created so we can set the mode. */
>                 /* Do we care about the CreateAction in any other cases? */
>                 if (cpu_to_le32(FILE_CREATE) == pSMBr->CreateAction)
>                         *pOplock |= CIFS_CREATE_ACTION;
>                 if (pfile_info) {
>                         memcpy((char *)pfile_info, (char *)&pSMBr->CreationTime,
>                                 36 /* CreationTime to Attributes */);
>                         /* the file_info buf is endian converted by caller */
>                         pfile_info->AllocationSize = pSMBr->AllocationSize;
>                         pfile_info->EndOfFile = pSMBr->EndOfFile;
>                         pfile_info->NumberOfLinks = cpu_to_le32(1);
>                         pfile_info->DeletePending = 0;
>                 }
>         }
> 
> In particular, the NumberOfLinks being set to 1 there. That probably
> just needs to go. I'll look over it when I have time.
> 

Looks like bogus value is being set temporarily here. The only call I
see that gets us nlink is SMBQpathInfo.

One way of addressing this is to pass NULL FILE_ALL_INFO buffer to
CIFSSMBOpen from cifs_create()/cifs_open()/cifs_mknod() so that
cifs_get_file_info will call SMBQPathInfo to populate FILE_ALL_INFO, but
it means additional QPATHINFO call. Another way is to get nlink value
from CIFSSMBQPathInfo response by adding nlink to cifsInodeInfo struct..
Neither sounds quite convincing to me..

Any thoughts, other possible approaches?


Thanks,


-- 
Suresh Jayaraman
