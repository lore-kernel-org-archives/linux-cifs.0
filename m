From: Steve French <smfrench@gmail.com>
Subject: Re: [RFC] extending splice for copy offloading
Date: Wed, 9 Oct 2013 21:18:58 -0500
Message-ID: <CAH2r5msOE3pjPronaXvC4CU6ddxBcF8-xLnviKTCi577uwDT+Q@mail.gmail.com>
References: <CAH2r5muBuTK7ZZ+aKGC4q35gqaSWF4o07eoHypLKiNn5Y83RbQ@mail.gmail.com>
	<20130926213451.33570dc4@linux-y6zt.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
To: David Disseldorp <ddiss@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130926213451.33570dc4@linux-y6zt.site>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Sep 26, 2013 at 2:34 PM, David Disseldorp <ddiss@suse.de> wrote:
> Hi Steve,
>
> On Thu, 26 Sep 2013 12:22:49 -0500
> Steve French <smfrench@gmail.com> wrote:
>
>> Windows clients seem to max out at 16MB chunk size when doing copy
>> offload.   I would like to increase chunk size larger than that if
>> network bandwidth (returned at mount time in SMB3 on the query network
>> interfaces FSCTL) is large enough, and response time is not more than
>> 100 (?) milliseconds.
>
> Sounds good, though with Samba and Btrfs the request latency will be
> heavily effected by whether the FSCTL_SRV_COPYCHUNK wire request byte
> offsets and lengths align to the Btrfs sector-size (4K by default
> IIRC).
> If they do align, then each chunk in the request can be mapped to a
> BTRFS_IOC_CLONE_RANGE ioctl. Otherwise, we need to fall back to a
> server-side local read/write.
>
> We should be able to provide underlying filesystem alignment
> requirements to SMB clients via the new FileFSSectorSizeInformation
> ioctl, but it's not currently supported by Samba.

I just posted a patch for the kernel client to request this information (when
SMB3 is requested) but Windows 8 for both SSD and spinning disk
was returning 512 byte for logical and physical and best
performance sector sizes.  So alignment for the CopyChunk chunks
that I will request on refcopy request will be straightforward.

It was great that the system reports the SSD vs. non-SSD correctly
with this new FSCTL.  Hopefully we can add a Samba VFS routine
to report this info - although not sure how we can request info
from the kernel to fill in these flags and fields.

#define SSINFO_FLAGS_ALIGNED_DEVICE        0x00000001
#define SSINFO_FLAGS_PARTITION_ALIGNED_ON_DEVICE 0x00000002
#define SSINFO_FLAGS_NO_SEEK_PENALTY        0x00000004 /* SSD */
#define SSINFO_FLAGS_TRIM_ENABLED        0x00000008

/* sector size info struct for new level 11 Query FS Info */
struct smb3_fs_ss_info {
    __le32 LogicalBytesPerSector;
    __le32 PhysicalBytesPerSectorForAtomicity;
    __le32 PhysicalBytesPerSectorForPerf;
    __le32 FileSystemEffectivePhysicalBytesPerSectorForAtomicity;
    __le32 Flags;
    __le32 ByteOffsetForSectorAlignment;
    __le32 ByteOffsetForPartitionAlignment;
}

-- 
Thanks,

Steve
