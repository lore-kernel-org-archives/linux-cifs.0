From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Strange hardlink behavior with CIFS
Date: Thu, 28 Oct 2010 07:46:50 -0400
Message-ID: <20101028074650.3e035241@tlielax.poochiereds.net>
References: <1287428685.16450.282.camel@calx>
	<4CBD6843.3060702@suse.de>
	<1288200686.3764.55.camel@calx>
	<20101027163230.28591971@tlielax.poochiereds.net>
	<4CC959AC.10301@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CC959AC.10301-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 28 Oct 2010 16:38:28 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 10/28/2010 02:02 AM, Jeff Layton wrote:
> > On Wed, 27 Oct 2010 12:31:26 -0500
> > Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org> wrote:
> > 
> >> On Tue, 2010-10-19 at 15:13 +0530, Suresh Jayaraman wrote:
> >>> On 10/19/2010 12:34 AM, Matt Mackall wrote:
> >>>> With Linux 2.6.32-35 and either Windows or Samba in nounix mode,
> >>>> hardlink counts can mysteriously disappear:
> >>>>
> >>>> - create hardlink pair foo,bar
> >>>> - stat foo -> nlink = 2
> >>>> - open foo
> >>>> - stat foo -> nlink = 1
> >>>> - close
> >>>> - wait or sync
> >>>> - ls -l -> nlink = 2
> >>>>
> >>>> Original report is here:
> >>>>
> >>>> http://mercurial.selenic.com/bts/issue1866
> >>>>
> >>>
> >>> A quick test on 2.6.36-rc4 kernel reveals that the problem is no longer
> >>> reproducible. Could you try a more recent kernel and see whether the
> >>> problem is reproducible?
> >>
> >> Test continues to fail with 2.6.36.
> >>
> >> # uname -a
> >> Linux calx 2.6.36 #71 SMP Tue Oct 26 02:23:34 CDT 2010 x86_64 GNU/Linux
> >> # mount -o nounix //localhost/stuff cifs
> >>            ^^^^^^
> >> # cd cifs
> >> # touch foo
> >> # ln foo bar
> >> # ./h
> >> file: foo nlinks 2
> >> file: foo nlinks 1
> >> file: foo nlinks 1
> >>
> >> # cat h.c
> >> #include <sys/types.h>
> >> #include <sys/stat.h>
> >> #include <unistd.h>
> >> #include <fcntl.h>
> >> #include <stdio.h>
> >>
> >> #define FPATH "foo"
> >>
> >> int main(void)
> >> {
> >> 	int rc, fh;
> >> 	struct stat st;
> >>
> >> 	rc = lstat(FPATH, &st);
> >> 	printf("file: %s nlinks %d\n", FPATH, st.st_nlink);
> >>
> >> 	fh = open(FPATH, 0, O_RDONLY);
> >>
> >> 	rc = lstat(FPATH, &st);
> >> 	printf("file: %s nlinks %d\n", FPATH, st.st_nlink);
> >>
> >> 	close(fh);
> >>
> >> 	rc = lstat(FPATH, &st);
> >> 	printf("file: %s nlinks %d\n", FPATH, st.st_nlink);
> >>
> >> 	return 0;
> >> }
> >>
> >>
> >>
> >>
> > 
> > Ok, I can reproduce this too. The problem is this nastiness in CIFSSMBOpen:
> > 
> >         if (rc) {
> >                 cFYI(1, "Error in Open = %d", rc);
> >         } else {
> >                 *pOplock = pSMBr->OplockLevel; /* 1 byte no need to le_to_cpu */
> >                 *netfid = pSMBr->Fid;   /* cifs fid stays in le */
> >                 /* Let caller know file was created so we can set the mode. */
> >                 /* Do we care about the CreateAction in any other cases? */
> >                 if (cpu_to_le32(FILE_CREATE) == pSMBr->CreateAction)
> >                         *pOplock |= CIFS_CREATE_ACTION;
> >                 if (pfile_info) {
> >                         memcpy((char *)pfile_info, (char *)&pSMBr->CreationTime,
> >                                 36 /* CreationTime to Attributes */);
> >                         /* the file_info buf is endian converted by caller */
> >                         pfile_info->AllocationSize = pSMBr->AllocationSize;
> >                         pfile_info->EndOfFile = pSMBr->EndOfFile;
> >                         pfile_info->NumberOfLinks = cpu_to_le32(1);
> >                         pfile_info->DeletePending = 0;
> >                 }
> >         }
> > 
> > In particular, the NumberOfLinks being set to 1 there. That probably
> > just needs to go. I'll look over it when I have time.
> > 
> 
> Looks like bogus value is being set temporarily here. The only call I
> see that gets us nlink is SMBQpathInfo.
> 
> One way of addressing this is to pass NULL FILE_ALL_INFO buffer to
> CIFSSMBOpen from cifs_create()/cifs_open()/cifs_mknod() so that
> cifs_get_file_info will call SMBQPathInfo to populate FILE_ALL_INFO, but
> it means additional QPATHINFO call. Another way is to get nlink value
> from CIFSSMBQPathInfo response by adding nlink to cifsInodeInfo struct..
> Neither sounds quite convincing to me..
> 
> Any thoughts, other possible approaches?
> 

Well...the open call returns some values that we can use to update the
inode. OTOH, the attribute cache timeout is 1s, so on an open we will
almost always have recently updated the attribute cache via QPathInfo
call.

I think we ought to not have CIFSSMBOpen try to fake up values since
it's clearly incorrect. The easiest way is just to get rid of the
places that try to do that (like this one).

If we feel that it's important to try and use the values that are
returned from this call (and others that fake up a QPathInfo response
like this), then they ought to changed so that they put the info into a
cifs_fattr struct and then update the inode values from that.

To do that however, you'll need to fix cifs_fattr_to_inode to only
update the values that have been set in the cifs_fattr so that you're
not faking up other values. That may mean adding a "valid" field of
some sort and setting flags that show which fields should be copied to
the inode.

Another approach would be to copy the fields from the open response to
a cifs_fattr and then populate the remaining fields with the existing
values in the inode. That might be ok, but could be more racy than the
first approach.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
