From: kbuild test robot <lkp@intel.com>
Subject: Re: [Patch v2 13/15] CIFS: Add support for direct I/O read
Date: Sat, 2 Jun 2018 15:15:08 +0800
Message-ID: <201806021330.FQvRPcaq%fengguang.wu@intel.com>
References: <20180530194807.31657-14-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="d6Gm4EdcadzBjdND"
Cc: kbuild-all@01.org, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>
To: Long Li <longli@linuxonhyperv.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180530194807.31657-14-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Long,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on v4.17-rc6]
[cannot apply to cifs/for-next next-20180601]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Long-Li/CIFS-Add-direct-I-O-support/20180602-130240
config: i386-randconfig-x008-201821 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   In file included from include/linux/kernel.h:14:0,
                    from include/linux/list.h:9,
                    from include/linux/wait.h:7,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:6,
                    from fs//cifs/file.c:24:
   fs//cifs/file.c: In function 'cifs_direct_readv':
   include/linux/kern_levels.h:5:18: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'size_t {aka unsigned int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/printk.h:136:10: note: in definition of macro 'no_printk'
      printk(fmt, ##__VA_ARGS__);  \
             ^~~
   include/linux/kern_levels.h:15:20: note: in expansion of macro 'KERN_SOH'
    #define KERN_DEBUG KERN_SOH "7" /* debug-level messages */
                       ^~~~~~~~
   include/linux/printk.h:410:12: note: in expansion of macro 'KERN_DEBUG'
     no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
               ^~~~~~~~~~
   fs//cifs/cifs_debug.h:54:3: note: in expansion of macro 'pr_debug_once'
      pr_debug_ ## ratefunc("%s: "   \
      ^~~~~~~~~
   fs//cifs/cifs_debug.h:67:3: note: in expansion of macro 'cifs_dbg_func'
      cifs_dbg_func(once,   \
      ^~~~~~~~~~~~~
>> fs//cifs/file.c:3346:4: note: in expansion of macro 'cifs_dbg'
       cifs_dbg(VFS,
       ^~~~~~~~
   fs//cifs/file.c:3348:20: note: format string is defined here
        " iov_offset %lu count %lu\n",
                     ~~^
                     %u
   In file included from include/linux/kernel.h:14:0,
                    from include/linux/list.h:9,
                    from include/linux/wait.h:7,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:6,
                    from fs//cifs/file.c:24:
   include/linux/kern_levels.h:5:18: warning: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'size_t {aka unsigned int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/printk.h:136:10: note: in definition of macro 'no_printk'
      printk(fmt, ##__VA_ARGS__);  \
             ^~~
   include/linux/kern_levels.h:15:20: note: in expansion of macro 'KERN_SOH'
    #define KERN_DEBUG KERN_SOH "7" /* debug-level messages */
                       ^~~~~~~~
   include/linux/printk.h:410:12: note: in expansion of macro 'KERN_DEBUG'
     no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
               ^~~~~~~~~~
   fs//cifs/cifs_debug.h:54:3: note: in expansion of macro 'pr_debug_once'
      pr_debug_ ## ratefunc("%s: "   \
      ^~~~~~~~~
   fs//cifs/cifs_debug.h:67:3: note: in expansion of macro 'cifs_dbg_func'
      cifs_dbg_func(once,   \
      ^~~~~~~~~~~~~
>> fs//cifs/file.c:3346:4: note: in expansion of macro 'cifs_dbg'
       cifs_dbg(VFS,
       ^~~~~~~~
   fs//cifs/file.c:3348:30: note: format string is defined here
        " iov_offset %lu count %lu\n",
                               ~~^
                               %u
   In file included from include/linux/kernel.h:14:0,
                    from include/linux/list.h:9,
                    from include/linux/wait.h:7,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:6,
                    from fs//cifs/file.c:24:
   include/linux/kern_levels.h:5:18: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type 'size_t {aka unsigned int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/printk.h:357:10: note: in definition of macro 'printk_once'
      printk(fmt, ##__VA_ARGS__);   \
             ^~~
   include/linux/kern_levels.h:11:18: note: in expansion of macro 'KERN_SOH'
    #define KERN_ERR KERN_SOH "3" /* error conditions */
                     ^~~~~~~~
   include/linux/printk.h:386:14: note: in expansion of macro 'KERN_ERR'
     printk_once(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                 ^~~~~~~~
   fs//cifs/cifs_debug.h:57:3: note: in expansion of macro 'pr_err_once'
      pr_err_ ## ratefunc("CIFS VFS: "  \
      ^~~~~~~
   fs//cifs/cifs_debug.h:67:3: note: in expansion of macro 'cifs_dbg_func'
      cifs_dbg_func(once,   \
      ^~~~~~~~~~~~~
>> fs//cifs/file.c:3346:4: note: in expansion of macro 'cifs_dbg'
       cifs_dbg(VFS,
       ^~~~~~~~
   fs//cifs/file.c:3348:20: note: format string is defined here
        " iov_offset %lu count %lu\n",
                     ~~^
                     %u
   In file included from include/linux/kernel.h:14:0,
                    from include/linux/list.h:9,
                    from include/linux/wait.h:7,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:6,
                    from fs//cifs/file.c:24:
   include/linux/kern_levels.h:5:18: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'size_t {aka unsigned int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/printk.h:357:10: note: in definition of macro 'printk_once'
      printk(fmt, ##__VA_ARGS__);   \
             ^~~
   include/linux/kern_levels.h:11:18: note: in expansion of macro 'KERN_SOH'
    #define KERN_ERR KERN_SOH "3" /* error conditions */
                     ^~~~~~~~
   include/linux/printk.h:386:14: note: in expansion of macro 'KERN_ERR'
     printk_once(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                 ^~~~~~~~
   fs//cifs/cifs_debug.h:57:3: note: in expansion of macro 'pr_err_once'
      pr_err_ ## ratefunc("CIFS VFS: "  \
      ^~~~~~~
   fs//cifs/cifs_debug.h:67:3: note: in expansion of macro 'cifs_dbg_func'
      cifs_dbg_func(once,   \
      ^~~~~~~~~~~~~
>> fs//cifs/file.c:3346:4: note: in expansion of macro 'cifs_dbg'
       cifs_dbg(VFS,
       ^~~~~~~~
   fs//cifs/file.c:3348:30: note: format string is defined here
        " iov_offset %lu count %lu\n",
                               ~~^
                               %u
   In file included from include/linux/kernel.h:14:0,
                    from include/linux/list.h:9,
                    from include/linux/wait.h:7,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:6,
                    from fs//cifs/file.c:24:
   include/linux/kern_levels.h:5:18: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type 'size_t {aka unsigned int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/printk.h:136:10: note: in definition of macro 'no_printk'
      printk(fmt, ##__VA_ARGS__);  \
             ^~~
   include/linux/kern_levels.h:15:20: note: in expansion of macro 'KERN_SOH'
    #define KERN_DEBUG KERN_SOH "7" /* debug-level messages */
                       ^~~~~~~~
   include/linux/printk.h:410:12: note: in expansion of macro 'KERN_DEBUG'
     no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
               ^~~~~~~~~~
   fs//cifs/cifs_debug.h:60:3: note: in expansion of macro 'pr_debug_once'
      pr_debug_ ## ratefunc(fmt, ##__VA_ARGS__); \
      ^~~~~~~~~
   fs//cifs/cifs_debug.h:67:3: note: in expansion of macro 'cifs_dbg_func'
      cifs_dbg_func(once,   \
      ^~~~~~~~~~~~~
>> fs//cifs/file.c:3346:4: note: in expansion of macro 'cifs_dbg'
       cifs_dbg(VFS,
       ^~~~~~~~
   fs//cifs/file.c:3348:20: note: format string is defined here
        " iov_offset %lu count %lu\n",
                     ~~^
                     %u
   In file included from include/linux/kernel.h:14:0,
                    from include/linux/list.h:9,
                    from include/linux/wait.h:7,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:6,
                    from fs//cifs/file.c:24:
   include/linux/kern_levels.h:5:18: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'size_t {aka unsigned int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/printk.h:136:10: note: in definition of macro 'no_printk'
      printk(fmt, ##__VA_ARGS__);  \
             ^~~
   include/linux/kern_levels.h:15:20: note: in expansion of macro 'KERN_SOH'
    #define KERN_DEBUG KERN_SOH "7" /* debug-level messages */
                       ^~~~~~~~
   include/linux/printk.h:410:12: note: in expansion of macro 'KERN_DEBUG'
     no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
               ^~~~~~~~~~
   fs//cifs/cifs_debug.h:60:3: note: in expansion of macro 'pr_debug_once'
      pr_debug_ ## ratefunc(fmt, ##__VA_ARGS__); \
      ^~~~~~~~~
   fs//cifs/cifs_debug.h:67:3: note: in expansion of macro 'cifs_dbg_func'
      cifs_dbg_func(once,   \
      ^~~~~~~~~~~~~
>> fs//cifs/file.c:3346:4: note: in expansion of macro 'cifs_dbg'
       cifs_dbg(VFS,
       ^~~~~~~~
   fs//cifs/file.c:3348:30: note: format string is defined here
        " iov_offset %lu count %lu\n",
                               ~~^
                               %u
   In file included from include/linux/kernel.h:14:0,
                    from include/linux/list.h:9,
                    from include/linux/wait.h:7,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:6,
                    from fs//cifs/file.c:24:
   include/linux/kern_levels.h:5:18: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'size_t {aka unsigned int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/printk.h:136:10: note: in definition of macro 'no_printk'
      printk(fmt, ##__VA_ARGS__);  \
             ^~~
   include/linux/kern_levels.h:15:20: note: in expansion of macro 'KERN_SOH'
    #define KERN_DEBUG KERN_SOH "7" /* debug-level messages */
                       ^~~~~~~~
   include/linux/printk.h:474:12: note: in expansion of macro 'KERN_DEBUG'
     no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
               ^~~~~~~~~~
   fs//cifs/cifs_debug.h:54:3: note: in expansion of macro 'pr_debug_ratelimited'
      pr_debug_ ## ratefunc("%s: "   \
      ^~~~~~~~~
   fs//cifs/cifs_debug.h:70:3: note: in expansion of macro 'cifs_dbg_func'
      cifs_dbg_func(ratelimited,  \
      ^~~~~~~~~~~~~
>> fs//cifs/file.c:3346:4: note: in expansion of macro 'cifs_dbg'
       cifs_dbg(VFS,
       ^~~~~~~~
   fs//cifs/file.c:3348:20: note: format string is defined here
        " iov_offset %lu count %lu\n",
                     ~~^
                     %u
   In file included from include/linux/kernel.h:14:0,
                    from include/linux/list.h:9,
                    from include/linux/wait.h:7,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:6,
                    from fs//cifs/file.c:24:
   include/linux/kern_levels.h:5:18: warning: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'size_t {aka unsigned int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/printk.h:136:10: note: in definition of macro 'no_printk'
      printk(fmt, ##__VA_ARGS__);  \
             ^~~
   include/linux/kern_levels.h:15:20: note: in expansion of macro 'KERN_SOH'
    #define KERN_DEBUG KERN_SOH "7" /* debug-level messages */
                       ^~~~~~~~
   include/linux/printk.h:474:12: note: in expansion of macro 'KERN_DEBUG'
     no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
               ^~~~~~~~~~
   fs//cifs/cifs_debug.h:54:3: note: in expansion of macro 'pr_debug_ratelimited'
      pr_debug_ ## ratefunc("%s: "   \
      ^~~~~~~~~
   fs//cifs/cifs_debug.h:70:3: note: in expansion of macro 'cifs_dbg_func'
      cifs_dbg_func(ratelimited,  \
      ^~~~~~~~~~~~~
>> fs//cifs/file.c:3346:4: note: in expansion of macro 'cifs_dbg'
       cifs_dbg(VFS,
       ^~~~~~~~
   fs//cifs/file.c:3348:30: note: format string is defined here
        " iov_offset %lu count %lu\n",
                               ~~^
                               %u
   In file included from include/linux/kernel.h:14:0,
                    from include/linux/list.h:9,
                    from include/linux/wait.h:7,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:6,
                    from fs//cifs/file.c:24:
   include/linux/kern_levels.h:5:18: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type 'size_t {aka unsigned int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/printk.h:425:10: note: in definition of macro 'printk_ratelimited'
      printk(fmt, ##__VA_ARGS__);    \
             ^~~
   include/linux/kern_levels.h:11:18: note: in expansion of macro 'KERN_SOH'
    #define KERN_ERR KERN_SOH "3" /* error conditions */
                     ^~~~~~~~
   include/linux/printk.h:439:21: note: in expansion of macro 'KERN_ERR'
     printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                        ^~~~~~~~
   fs//cifs/cifs_debug.h:57:3: note: in expansion of macro 'pr_err_ratelimited'
      pr_err_ ## ratefunc("CIFS VFS: "  \
      ^~~~~~~
   fs//cifs/cifs_debug.h:70:3: note: in expansion of macro 'cifs_dbg_func'
      cifs_dbg_func(ratelimited,  \
      ^~~~~~~~~~~~~
>> fs//cifs/file.c:3346:4: note: in expansion of macro 'cifs_dbg'
       cifs_dbg(VFS,
       ^~~~~~~~
   fs//cifs/file.c:3348:20: note: format string is defined here
        " iov_offset %lu count %lu\n",
                     ~~^
                     %u
   In file included from include/linux/kernel.h:14:0,
                    from include/linux/list.h:9,
                    from include/linux/wait.h:7,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:6,
                    from fs//cifs/file.c:24:
   include/linux/kern_levels.h:5:18: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'size_t {aka unsigned int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/printk.h:425:10: note: in definition of macro 'printk_ratelimited'
      printk(fmt, ##__VA_ARGS__);    \
             ^~~
   include/linux/kern_levels.h:11:18: note: in expansion of macro 'KERN_SOH'
    #define KERN_ERR KERN_SOH "3" /* error conditions */
                     ^~~~~~~~
   include/linux/printk.h:439:21: note: in expansion of macro 'KERN_ERR'
     printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                        ^~~~~~~~
   fs//cifs/cifs_debug.h:57:3: note: in expansion of macro 'pr_err_ratelimited'
      pr_err_ ## ratefunc("CIFS VFS: "  \
      ^~~~~~~
   fs//cifs/cifs_debug.h:70:3: note: in expansion of macro 'cifs_dbg_func'
      cifs_dbg_func(ratelimited,  \
      ^~~~~~~~~~~~~
>> fs//cifs/file.c:3346:4: note: in expansion of macro 'cifs_dbg'
       cifs_dbg(VFS,
       ^~~~~~~~
   fs//cifs/file.c:3348:30: note: format string is defined here
        " iov_offset %lu count %lu\n",
                               ~~^
                               %u
   In file included from include/linux/kernel.h:14:0,
                    from include/linux/list.h:9,
                    from include/linux/wait.h:7,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:6,
                    from fs//cifs/file.c:24:
   include/linux/kern_levels.h:5:18: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type 'size_t {aka unsigned int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/printk.h:136:10: note: in definition of macro 'no_printk'
      printk(fmt, ##__VA_ARGS__);  \
             ^~~
   include/linux/kern_levels.h:15:20: note: in expansion of macro 'KERN_SOH'
    #define KERN_DEBUG KERN_SOH "7" /* debug-level messages */
                       ^~~~~~~~
   include/linux/printk.h:474:12: note: in expansion of macro 'KERN_DEBUG'
     no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
               ^~~~~~~~~~
   fs//cifs/cifs_debug.h:60:3: note: in expansion of macro 'pr_debug_ratelimited'
      pr_debug_ ## ratefunc(fmt, ##__VA_ARGS__); \
      ^~~~~~~~~
   fs//cifs/cifs_debug.h:70:3: note: in expansion of macro 'cifs_dbg_func'
      cifs_dbg_func(ratelimited,  \
      ^~~~~~~~~~~~~
>> fs//cifs/file.c:3346:4: note: in expansion of macro 'cifs_dbg'
       cifs_dbg(VFS,
       ^~~~~~~~
   fs//cifs/file.c:3348:20: note: format string is defined here
        " iov_offset %lu count %lu\n",
                     ~~^
                     %u
   In file included from include/linux/kernel.h:14:0,
                    from include/linux/list.h:9,
                    from include/linux/wait.h:7,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:6,
                    from fs//cifs/file.c:24:
   include/linux/kern_levels.h:5:18: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'size_t {aka unsigned int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/printk.h:136:10: note: in definition of macro 'no_printk'
      printk(fmt, ##__VA_ARGS__);  \
             ^~~
   include/linux/kern_levels.h:15:20: note: in expansion of macro 'KERN_SOH'
    #define KERN_DEBUG KERN_SOH "7" /* debug-level messages */
                       ^~~~~~~~
   include/linux/printk.h:474:12: note: in expansion of macro 'KERN_DEBUG'
     no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
               ^~~~~~~~~~
   fs//cifs/cifs_debug.h:60:3: note: in expansion of macro 'pr_debug_ratelimited'
      pr_debug_ ## ratefunc(fmt, ##__VA_ARGS__); \
      ^~~~~~~~~
   fs//cifs/cifs_debug.h:70:3: note: in expansion of macro 'cifs_dbg_func'
      cifs_dbg_func(ratelimited,  \
      ^~~~~~~~~~~~~
>> fs//cifs/file.c:3346:4: note: in expansion of macro 'cifs_dbg'
       cifs_dbg(VFS,
       ^~~~~~~~
   fs//cifs/file.c:3348:30: note: format string is defined here
        " iov_offset %lu count %lu\n",
                               ~~^
                               %u

vim +/cifs_dbg +3346 fs//cifs/file.c

  3290	
  3291	ssize_t cifs_direct_readv(struct kiocb *iocb, struct iov_iter *to)
  3292	{
  3293		size_t len, cur_len, start;
  3294		unsigned int npages, rsize, credits;
  3295		struct file *file;
  3296		struct cifs_sb_info *cifs_sb;
  3297		struct cifsFileInfo *cfile;
  3298		struct cifs_tcon *tcon;
  3299		struct page **pagevec;
  3300		ssize_t rc, total_read = 0;
  3301		struct TCP_Server_Info *server;
  3302		loff_t offset = iocb->ki_pos;
  3303		pid_t pid;
  3304		struct cifs_readdata *rdata;
  3305	
  3306		/*
  3307		 * iov_iter_get_pages_alloc() doesn't work with ITER_KVEC,
  3308		 * fall back to data copy read path
  3309		 */
  3310		if (to->type & ITER_KVEC) {
  3311			cifs_dbg(FYI, "use non-direct cifs_user_readv for kvec I/O\n");
  3312			return cifs_user_readv(iocb, to);
  3313		}
  3314	
  3315		len = iov_iter_count(to);
  3316		if (!len)
  3317			return 0;
  3318	
  3319		file = iocb->ki_filp;
  3320		cifs_sb = CIFS_FILE_SB(file);
  3321		cfile = file->private_data;
  3322		tcon = tlink_tcon(cfile->tlink);
  3323		server = tcon->ses->server;
  3324	
  3325		if (!server->ops->async_readv)
  3326			return -ENOSYS;
  3327	
  3328		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
  3329			pid = cfile->pid;
  3330		else
  3331			pid = current->tgid;
  3332	
  3333		if ((file->f_flags & O_ACCMODE) == O_WRONLY)
  3334			cifs_dbg(FYI, "attempting read on write only file instance\n");
  3335	
  3336		do {
  3337			rc = server->ops->wait_mtu_credits(server, cifs_sb->rsize,
  3338						&rsize, &credits);
  3339			if (rc)
  3340				break;
  3341	
  3342			cur_len = min_t(const size_t, len, rsize);
  3343	
  3344			rc = iov_iter_get_pages_alloc(to, &pagevec, cur_len, &start);
  3345			if (rc < 0) {
> 3346				cifs_dbg(VFS,
  3347					"couldn't get user pages (rc=%zd) iter type %d"
  3348					" iov_offset %lu count %lu\n",
  3349					rc, to->type, to->iov_offset, to->count);
  3350				dump_stack();
  3351				break;
  3352			}
  3353	
  3354			rdata = cifs_readdata_direct_alloc(
  3355					pagevec, cifs_direct_readv_complete);
  3356			if (!rdata) {
  3357				add_credits_and_wake_if(server, credits, 0);
  3358				rc = -ENOMEM;
  3359				break;
  3360			}
  3361	
  3362			npages = (rc + start + PAGE_SIZE-1) / PAGE_SIZE;
  3363			rdata->nr_pages = npages;
  3364			rdata->page_offset = start;
  3365			rdata->pagesz = PAGE_SIZE;
  3366			rdata->tailsz = npages > 1 ?
  3367					rc-(PAGE_SIZE-start)-(npages-2)*PAGE_SIZE :
  3368					rc;
  3369			cur_len = rc;
  3370	
  3371			rdata->cfile = cifsFileInfo_get(cfile);
  3372			rdata->offset = offset;
  3373			rdata->bytes = rc;
  3374			rdata->pid = pid;
  3375			rdata->read_into_pages = cifs_uncached_read_into_pages;
  3376			rdata->copy_into_pages = cifs_uncached_copy_into_pages;
  3377			rdata->credits = credits;
  3378	
  3379			rc = 0;
  3380			if (rdata->cfile->invalidHandle)
  3381				rc = cifs_reopen_file(rdata->cfile, true);
  3382	
  3383			if (!rc)
  3384				rc = server->ops->async_readv(rdata);
  3385	
  3386			if (rc) {
  3387				add_credits_and_wake_if(server, rdata->credits, 0);
  3388				kref_put(&rdata->refcount,
  3389					 cifs_direct_readdata_release);
  3390				if (rc == -EAGAIN)
  3391					continue;
  3392				break;
  3393			}
  3394	
  3395			wait_for_completion(&rdata->done);
  3396			rc = rdata->result;
  3397			if (rc) {
  3398				kref_put(
  3399					&rdata->refcount,
  3400					cifs_direct_readdata_release);
  3401				if (rc == -EAGAIN)
  3402					continue;
  3403				break;
  3404			}
  3405	
  3406			total_read += rdata->got_bytes;
  3407			kref_put(&rdata->refcount, cifs_direct_readdata_release);
  3408	
  3409			iov_iter_advance(to, cur_len);
  3410			len -= cur_len;
  3411			offset += cur_len;
  3412		} while (len);
  3413	
  3414		iocb->ki_pos += total_read;
  3415	
  3416		return total_read;
  3417	}
  3418	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--d6Gm4EdcadzBjdND
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--d6Gm4EdcadzBjdND--
