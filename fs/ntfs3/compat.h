/* SPDX-License-Identifier: GPL-2.0 */

#ifndef SECTOR_SHIFT
#define SECTOR_SHIFT 9
#endif
#ifndef SECTOR_SIZE
#define SECTOR_SIZE (1 << SECTOR_SHIFT)
#endif

#ifndef __bitmap_set
#define __bitmap_set(a, b, c)	bitmap_set(a, b, c)
#endif

#ifndef __bitmap_clear
#define __bitmap_clear(a, b, c)	bitmap_clear(a, b, c)
#endif

/*
 * Copy from include/linux/compiler_attributes.h
 */
#ifndef __has_attribute
#define __has_attribute(x) 0
#endif

#ifndef fallthrough
#if __has_attribute(__fallthrough__)
#define fallthrough __attribute__((__fallthrough__))
#else
#define fallthrough do {} while (0)  /* fallthrough */
#endif
#endif

/*
 * Copy from include/linux/build_bug.h
 */
#ifndef static_assert
#define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
#define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
#endif

/*
 * Copy from include/linux/overflow.h
 */
#ifndef struct_size
#define struct_size(p, member, n) (sizeof(*(p)) + n * sizeof(*(p)->member))
#endif

static inline void *kvmalloc(size_t size, gfp_t flags)
{
	void *ret;

	ret = kmalloc(size, flags | __GFP_NOWARN);
	if (!ret)
		ret = __vmalloc(size, flags, PAGE_KERNEL);
	return ret;
}
